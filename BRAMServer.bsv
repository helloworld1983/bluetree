// Member of: Bluetree (Server)
// Purpose: A Bluetree server implemented in block RAM
// Size is 2^11 = 2048 words = 8192 bytes
package BRAMServer;

export IfcBRAMServer(..);
export mkBRAMServer;

import FIFO::*;
import GetPut::*;
import StmtFSM::*;
import Bluetree::*;
import ClientServer::*;
import DReg::*;
import BlueBRAM::*;

// interface IfcConfigurableBRAMServer#(type bram_Block_Address_Bits);
//     interface BluetreeServer server;
// endinterface

interface IfcBRAMServer;
    interface BluetreeServer server;
endinterface


typedef Bit#(12) SPM_Address_Bits;

typedef struct {
    BluetreeBlockAddress    address;
    BluetreeTaskId          task_id;
    BluetreeCPUId           cpu_id;
    BluetreeMessageType     message_type;
} InternalRequest deriving (Bits, Eq);

//module mkConfigurableBRAMServer 
//                (IfcConfigurableBRAMServer#(SPM_Address_Bits));
(* synthesize *)
module mkBRAMServer (IfcBRAMServer);

    Reg#(BluetreeBurstCounter) count <- mkReg(0);

    Reg#(InternalRequest) rd <- mkReg(unpack(0));
    Reg#(InternalRequest) ram_out <- mkReg(unpack(0));

    Reg#(Bool) rd_active <- mkDReg(False);
    Reg#(Bool) ram_out_active <- mkReg(False);

    Integer val_SPM_Address_Bits = valueOf(SizeOf#(SPM_Address_Bits));

    IfcByteRAM#(SPM_Address_Bits, BluetreeData, BluetreeBEN)
                block_ram <- mkByteRAM("BRAMServer");
    
    FIFO#(BluetreeServerPacket) outFifo <- mkFIFO();
    
    rule continue_read if (count != 0);
        InternalRequest rdp = rd;
        rdp.address = rdp.address + 1;
        rd <= rdp;
        rd_active <= True;
        count <= count - 1;
    endrule

    rule same_time_as_ram;
        ram_out <= rd;
        ram_out_active <= rd_active;
	
        block_ram.a.put(0, rd.address[val_SPM_Address_Bits - 1 : 0 ], 0);
    endrule
    
    rule forward_to_fifo(ram_out_active);
	BluetreeServerPacket p = unpack(0);
	
	p.address = ram_out.address;
	p.task_id = ram_out.task_id;
	p.cpu_id = ram_out.cpu_id;
	p.data = block_ram.a.read();
	p.message_type = ram_out.message_type;

	outFifo.enq(p);
    endrule
    
    interface BluetreeServer server;
        interface Get response = toGet(outFifo);
        interface Put request;
            method Action put(BluetreeClientPacket p) if (count == 0);
                InternalRequest rdp = unpack(0);
                rdp.address = p.address;
                rdp.task_id = p.task_id;
                rdp.cpu_id = p.cpu_id;

                if (p.ben != 0) begin
                    SPM_Address_Bits wr_address = p.address[
                            val_SPM_Address_Bits - 1 : 0 ];
		    
//		    $display("BRAMServer: Writing to 0x%x BEN 0x%x Data 0x%x", wr_address, p.ben, p.data);
		    
                    // Write to memory
                    block_ram.b.put(p.ben, wr_address, p.data);
                    count <= 0;
                    rdp.message_type = BT_WRITE_ACK;
                end 
		else begin
                   // Start read from memory
//		    $display("BRAMServer: Reading from 0x%x", p.address);
		    count <= p.size;
		   if(p.message_type == BT_STANDARD)
		      rdp.message_type = BT_READ;
		   else
		      rdp.message_type = BT_PREFETCH;
                end

                rd <= rdp;
                rd_active <= True;
            endmethod
        endinterface
    endinterface
endmodule

// (* synthesize *)
// module mkBRAMServer (IfcBRAMServer);
//     IfcConfigurableBRAMServer#(Bit#(12)) bs <- mkConfigurableBRAMServer();
// 
//     interface server = bs.server;
// endmodule


endpackage
