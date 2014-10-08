// Member of: Bluetree (Server)
// Purpose: Connects an Bluetree bus to AXI, implementing an Bluetree server (RAM)
package AxiConn;

export IfcAxiConn(..);
export mkAxiConn;

import Bluetree::*;


import Axi::*;
import TLM2::*;
import FIFO::*;
import FIFOF::*;
import GetPut::*;
import ClientServer::*;

`include "Axi.defines"


//`define AXI_PRM 6, 32, 32, 10, Bit#(12)
//`define AXI_PRM_STD 4, 32, 32, 10, AxiCustom
//`define AXI_RR_STD TLMRequest#(`AXI_PRM_STD), TLMResponse#(`AXI_PRM_STD) 
//`define AXI_XTR_STD `AXI_RR_STD, `AXI_PRM_STD

`define MY_AXI_PRM_STD 4, 32, 128, 10, AxiCustom
`define MY_AXI_RR_STD TLMRequest#(`MY_AXI_PRM_STD), TLMResponse#(`MY_AXI_PRM_STD) 
`define MY_AXI_XTR_STD `MY_AXI_RR_STD, `MY_AXI_PRM_STD



interface IfcAxiConn;
    interface AxiRdFabricMaster#(`MY_AXI_PRM_STD) axi_read;
    interface AxiWrFabricMaster#(`MY_AXI_PRM_STD) axi_write;
    interface BluetreeServer server;
endinterface

typedef enum { AWAIT_COMMAND, WRITE_FIRST, WRITE_NTH, AWAIT_READ_ACK } 
            AxiConnState deriving (Bits, Eq);

typedef enum { CMD_GET_TIMESTAMP, CMD_GET_BLOCKED } AxiCommand deriving (Bits, Eq);

typedef struct {
    Bool                    is_read;
    Bool                    is_prefetch;
    BluetreeBlockAddress    address;
    BluetreeTaskId          task_id;
    BluetreeCPUId           cpu_id;
    BluetreeBurstCounter    burst_size;
} InternalRequest deriving (Bits, Eq);

(* synthesize *)
module mkAxiConn (IfcAxiConn);
    FIFO#(BluetreeClientPacket) to_mem_fifo <- mkFIFO();
    FIFO#(BluetreeServerPacket) from_mem_fifo <- mkFIFO();
    FIFOF#(InternalRequest) control_fifo <- mkFIFOF();
    Reg#(AxiConnState) state <- mkReg(AWAIT_COMMAND);
    Reg#(BluetreeBurstCounter) read_offset <- mkReg(0);

    PulseWire write_inc <- mkPulseWire();
    PulseWire write_dec <- mkPulseWire();
    PulseWire read_inc <- mkPulseWire();
    PulseWire read_dec <- mkPulseWire();

    IfcAxiWriter axi_writer <- mkAxiWriter();
    IfcAxiReader axi_reader <- mkAxiReader();


    Reg#(Bit#(8)) writes_active <- mkReg(0);
    Reg#(Bit#(8)) reads_active <- mkReg(0);
    
    Reg#(Bit#(64)) timestamp <- mkReg(0);
    Reg#(Bit#(64)) used_cycles <- mkReg(0);   
    
    Reg#(Bool) transaction_active <- mkReg(False);
    
    PulseWire transaction_start <- mkPulseWire();
    PulseWire transaction_end   <- mkPulseWire();
    
    rule r_inc_write if (write_inc && !write_dec);
        writes_active <= writes_active + 1;
    endrule
    
    rule r_dec_write if (write_dec && !write_inc);
        writes_active <= writes_active - 1;
    endrule

    rule r_inc_read if (read_inc && !read_dec);
        reads_active <= reads_active + 1;
    endrule
    
    rule r_dec_read if (read_dec && !read_inc);
        reads_active <= reads_active - 1;
    endrule
    
    rule update_transaction_active;
	if (transaction_start)
	    transaction_active <= True;
	else if (transaction_end)
	    transaction_active <= False;
    endrule

    rule timer;
        timestamp <= timestamp + 1;
    endrule
    
    rule transaction_timer if(transaction_active);
	used_cycles <= used_cycles + 1;
    endrule
    
    rule start_write if ((reads_active == 0)
			 && (to_mem_fifo.first().ben != 0)
			 && to_mem_fifo.first().message_type != BT_AXI_PROBE);

        BluetreeClientPacket p = to_mem_fifo.first();
        to_mem_fifo.deq();

        BluetreeByteAddress a1 = 0;
        BluetreeAddress a2 = {p.address, a1};

        write_inc.send();
        axi_writer.send_first(a2, p.data, p.ben);
	
	if(writes_active == 0) // If this is the first write in a transaction
	    transaction_start.send();
	
        InternalRequest r = unpack(0);
        r.address = p.address;
        r.task_id = p.task_id;
        r.cpu_id = p.cpu_id;
        r.is_read = False;
        control_fifo.enq(r);

        $display("AxiConn ts ", timestamp, " start_write ", 
                    p.data, " ", p.ben, " ", a2);
    endrule

    rule start_read if ((writes_active == 0)
			&& (to_mem_fifo.first().ben == 0)
			&& to_mem_fifo.first().message_type != BT_AXI_PROBE);
        BluetreeClientPacket p = to_mem_fifo.first();
        to_mem_fifo.deq();

        BluetreeByteAddress a1 = 0;
        BluetreeAddress a2 = {p.address, a1};
        read_inc.send();
        axi_reader.request(a2, p.size);

	if(reads_active == 0)
	    transaction_start.send();
	
        InternalRequest r = unpack(0);
        r.address = p.address;
        r.task_id = p.task_id;
        r.cpu_id = p.cpu_id;
        r.burst_size = p.size;
        r.is_read = True;
        r.is_prefetch = (p.message_type == BT_PREFETCH);
	control_fifo.enq(r);
	

        $display("AxiConn ts ", timestamp, " start_read ", a2, " ", p.size);
    endrule
    
    // Why not just do this on Bluetiles? Well, the AXI bus doesn't appear in the
    // top level Bluespec file, and is instead instantiated separately. Right now,
    // I'm not in a position to do the groundwork to be able to bring this
    // out onto Bluetiles, so we'll just do it over the tree instead.
    
    // Logically, a read/write complete can only fire in a cycle where there
    // is an active read/write. This can only fire in cycles where there are
    // no active read/writes, thus it is mutually exclusive to these rules.
    (* mutually_exclusive = "start_command, read_complete" *)
    (* mutually_exclusive = "start_command, write_complete" *)
    rule start_command if(to_mem_fifo.first().message_type == BT_AXI_PROBE &&
			  reads_active == 0 &&
			  writes_active == 0);
	BluetreeClientPacket pkt = to_mem_fifo.first();
	to_mem_fifo.deq();
	
	BluetreeServerPacket resp = unpack(0);
	resp.message_type = BT_AXI_PROBE;
//	resp.data = {timestamp,used_cycles};
	resp.data[127:64] = timestamp;
	resp.data[63:0] = used_cycles;
	resp.address = 0;
	resp.task_id = pkt.task_id;
	resp.cpu_id = pkt.cpu_id;
	
	from_mem_fifo.enq(resp);
    endrule

    rule read_complete if (control_fifo.first().is_read);
        InternalRequest r = control_fifo.first();
        BluetreeServerPacket p = unpack(0);

        p.data = axi_reader.first();
        p.task_id = r.task_id;
        p.cpu_id = r.cpu_id;
        p.address = r.address + {0, read_offset};
        p.message_type = r.is_prefetch ? BT_PREFETCH : BT_READ;

        axi_reader.deq();
	
	// Are we the last read (and make sure one hasn't just been issued)?

        if (read_offset == r.burst_size) begin
            // Final word
            read_dec.send();
            control_fifo.deq();
            read_offset <= 0;
	    
	    if(reads_active == 1 && !read_inc)
		transaction_end.send();
        end else begin
            // Non-final word
            read_offset <= read_offset + 1;
        end
        from_mem_fifo.enq(p);
        $display("AxiConn ts ", timestamp, " read ", p.data);
    endrule

    rule write_complete if (!control_fifo.first().is_read);
        InternalRequest r = control_fifo.first();
        BluetreeServerPacket p = unpack(0);

        p.task_id = r.task_id;
        p.cpu_id = r.cpu_id;
        p.address = r.address;
        p.message_type = BT_WRITE_ACK;

        axi_writer.deq();
        write_dec.send();
        control_fifo.deq();
	
	if(writes_active == 1 && !write_inc)
	    transaction_end.send();

        from_mem_fifo.enq(p);
        $display("AxiConn ts ", timestamp, " write_complete");
    endrule


    interface axi_read = axi_reader.axi_read;
    interface axi_write = axi_writer.axi_write;
    interface BluetreeServer server;
        interface request = toPut(to_mem_fifo);
        interface response = toGet(from_mem_fifo);
    endinterface
endmodule

interface IfcAxiReader;
    interface AxiRdFabricMaster#(`MY_AXI_PRM_STD) axi_read;
    method BluetreeData first();
    method Action deq();
    method Action request(BluetreeAddress addr, BluetreeBurstCounter burst_size);
endinterface

function RequestDescriptor#(`TLM_PRM) createDescriptor()
    provisos(Bits#(RequestDescriptor#(`TLM_PRM), s0),
            AxiConvert#(AxiCustom, cstm_type));

    RequestDescriptor#(`TLM_PRM) desc = unpack(0);

    // number of bytes in a burst:
    desc.burst_size = fromInteger(bluetreeBENSize - 1); 

    desc.burst_length = 1;
    desc.mode = REGULAR;
    desc.burst_mode = INCR;
    desc.thread_id = 0;
    desc.transaction_id = 0;
    desc.export_id = 0;
    desc.data = 0;
    desc.byte_enable = unpack(-1);
    return desc;
endfunction

function RequestData#(`TLM_PRM) createData()
    provisos(Bits#(RequestData#(`TLM_PRM), s0),
            AxiConvert#(AxiCustom, cstm_type));

    RequestData#(`TLM_PRM) data = unpack(0);
    return data;
endfunction

module mkAxiReader (IfcAxiReader)
        provisos(
                Add#(0, id_size, 4),
                Add#(0, addr_size, 32),
                Add#(0, data_size, 128),
                Add#(0, uint_size, 10));

    AxiRdMasterXActorIFC#(`MY_AXI_XTR_STD) r_master_0 <- 
                    mkAxiRdMaster();
    FIFO#(BluetreeData) data_fifo <- mkFIFO();

    rule receiver;
        let rsp <- r_master_0.tlm.tx.get();
        data_fifo.enq(rsp.data);
    endrule

    method Action request(Bit#(addr_size) addr, BluetreeBurstCounter burst_size);
        RequestDescriptor#(`MY_AXI_PRM_STD) desc = createDescriptor();
        desc.command = READ;
        desc.addr = addr;

        desc.burst_length = zeroExtend(fromSizedInteger(burst_size));
        desc.burst_length = desc.burst_length + 1;

	    TLMRequest#(`MY_AXI_PRM_STD) r = fromTLMRequest(tagged Descriptor desc);
        r_master_0.tlm.rx.put(r);
    endmethod

    method Bit#(data_size) first();
        return data_fifo.first();
    endmethod

    method Action deq();
        data_fifo.deq();
    endmethod

    interface axi_read = r_master_0.fabric;
endmodule

interface IfcAxiWriter;
    interface AxiWrFabricMaster#(`MY_AXI_PRM_STD) axi_write;
    method Action send_first(BluetreeAddress addr, BluetreeData data, 
                    BluetreeBEN byte_enable);
    method Action send_next(BluetreeData data);
    method Action deq();
endinterface

module mkAxiWriter (IfcAxiWriter)
        provisos(
                Add#(0, id_size, 4),
                Add#(0, addr_size, 32),
                Add#(0, data_size, 128),
                Add#(0, uint_size, 10));

    FIFO#(Bool) write_done <- mkFIFO();               
    AxiWrMasterXActorIFC#(`MY_AXI_XTR_STD) w_master_0 <- mkAxiWrMaster();

    rule sinker;
        let sink <- w_master_0.tlm.tx.get();
        write_done.enq(True);
    endrule

    method Action send_first(Bit#(addr_size) addr, BluetreeData data,
                            BluetreeBEN byte_enable);
        RequestDescriptor#(`MY_AXI_PRM_STD) desc = createDescriptor();
        desc.command = WRITE;
        desc.addr = addr;
        desc.data = data;
        desc.byte_enable = byte_enable;
        desc.burst_length = 1;
	    TLMRequest#(`MY_AXI_PRM_STD) w = fromTLMRequest(
                                    tagged Descriptor desc);
        w_master_0.tlm.rx.put(w);
    endmethod

    method Action send_next(BluetreeData data);
        RequestData#(`MY_AXI_PRM_STD) d = createData();
        d.data = data;
	    TLMRequest#(`MY_AXI_PRM_STD) w = fromTLMRequest(tagged Data d);
        w_master_0.tlm.rx.put(w);
    endmethod

    method Action deq();
        write_done.deq();
    endmethod

    interface axi_write = w_master_0.fabric;
endmodule



endpackage

