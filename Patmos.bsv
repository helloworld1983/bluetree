// Copyright (c) 2014 University of York
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

package Patmos;

export Patmos(..);
export mkPatmos;
export mkPatmosTreeClient;

//import Bluetiles::*;
import Bluetree::*;
import PatmosL0::*;
import GetPut::*;
import ClientServer::*;
import Clocks::*;
import PrioritySetReset::*;
import FIFO::*;
import FIFOF::*;

`define INTERFACE_OFFSET 0
`define RDSTAT_OFFSET 4
`define WRSTAT_OFFSET 8

typedef enum {
   OCP_IDLE,
   OCP_RD,
   OCP_WR,
   OCP_WAIT_RESP,
   OCP_GOT_RESP
} OcpState deriving (Bits, Eq);

interface Patmos;
    interface BluetreeClient client;
 //   interface BlueClient bluetile;
    method Action start();
endinterface

// TREE RESPONDER
module mkPatmosTreeClient#(OcpBurstMaster burst) (BluetreeClient);
    Reg#(BluetreeClientPacket) tmp_pkt <- mkReg(unpack(0));
    Reg#(UInt#(2)) pkt_rd_ptr <- mkReg(0);
    Reg#(Bool) pkt_ok <- mkReg(False);
    Reg#(OcpState) sm_state <- mkReg(OCP_IDLE);
    
    Reg#(BluetreeServerPacket) data_resp <- mkReg(unpack(0));
    Reg#(UInt#(2)) resp_rd_ptr <- mkReg(0);

    rule incoming_read(sm_state == OCP_IDLE && burst.get_MCmd() == OCMD_RD);
    	BluetreeClientPacket pkt = unpack(0);
    	pkt.address = truncate(burst.get_MAddr >> 4); // Shift off the useless bit
    	
    	tmp_pkt <= pkt;
    	pkt_ok <= True;
    	
    	sm_state <= OCP_WAIT_RESP;
    	
    	burst.put_SCmdAccept();
    	
    	$display("Handing read to addr 0x%x", burst.get_MAddr);
    endrule
    
    rule incoming_write(sm_state == OCP_IDLE && 
			burst.get_MCmd() == OCMD_WR && 
			burst.get_MDataValid() == 1);
    	BluetreeClientPacket pkt = unpack(0);
    	pkt.address = truncate(burst.get_MAddr() >> 4);
	
	// Should this be reversed?
    	pkt.data[127:96] = burst.get_MData();
    	pkt.ben[15:12] = burst.get_MBE();
    	
    	sm_state <= OCP_WR;
    	burst.put_SCmdAccept();
    	burst.put_SDataAccept();
    	
    	tmp_pkt <= pkt;
    	
    	// Next word
    	pkt_rd_ptr <= 1;
    	$display("Start write to address 0x%x D 0x%x BEN 0x%x", pkt.address, pkt.data, pkt.ben);
    endrule

    rule continue_write(sm_state == OCP_WR &&
			burst.get_MDataValid() == 1 &&
			pkt_ok == False);
    	BluetreeClientPacket pkt = tmp_pkt;
    	// Goddammit...wrong way around...
    //	pkt.data = pkt.data << 32 | zeroExtend(burst.get_MData());
    //	pkt.ben = pkt.ben << 4 | zeroExtend(burst.get_MBE());
    	
    	pkt.data = pkt.data >> 32;
    	pkt.data[127:96] = burst.get_MData();
    	pkt.ben = pkt.ben >> 4;
    	pkt.ben[15:12] = burst.get_MBE();
    	
    	$display("Continue write, D 0x%x, BEN 0x%x", pkt.data, pkt.ben);
    	
    	tmp_pkt <= pkt;
    	burst.put_SDataAccept();
    	
    	if(pkt_rd_ptr == 3) begin
    	    pkt_ok <= True;
    	    sm_state <= OCP_WAIT_RESP;
    	    pkt_rd_ptr <= 0;
    	    $display("Write complete, dispatching");
    	end 
    	else begin
    	    pkt_rd_ptr <= pkt_rd_ptr + 1;
    	end
    endrule
    
    (* descending_urgency="write_reply, tie_off_data" *)
    (* descending_urgency="write_reply, tie_off_resp" *)
    rule write_reply(sm_state == OCP_GOT_RESP);
    	(* split *)
    	if(data_resp.message_type == BT_WRITE_ACK) begin
    	    sm_state <= OCP_IDLE;
    	    burst.put_SResp(ORESP_DVA);
    	    burst.put_SData(0); // Because this will shadow tie_off_data since
    	                             // the IF isn't split
    	end
    	else begin
    	    burst.put_SResp(ORESP_DVA);
    //	    burst.put_SData(data_resp.data[127:96]);
    //	    data_resp.data <= data_resp.data << 32;

    	    burst.put_SData(data_resp.data[31:0]);
    	    data_resp.data <= data_resp.data >> 32;
    	    
    	    if(resp_rd_ptr == 3) begin
    		resp_rd_ptr <= 0;
    		sm_state <= OCP_IDLE;
    	    end 
    	    else
    		resp_rd_ptr <= resp_rd_ptr + 1;
    	end
    endrule
 
    // Lowest priority, denotes the resting states
    rule tie_off_resp;
	   burst.put_SResp(ORESP_IDLE);
    endrule
    
    rule tie_off_data;
	   burst.put_SData(0);
    endrule
    
    
    interface Get request;
    	method ActionValue#(BluetreeClientPacket) get() if(pkt_ok && sm_state == OCP_WAIT_RESP);
    	    pkt_ok <= False;
    	    return tmp_pkt;
    	endmethod
    endinterface
    
    interface Put response;
    	method Action put(BluetreeServerPacket pkt) if (sm_state == OCP_WAIT_RESP);
    	    data_resp <= pkt;
    	    sm_state <= OCP_GOT_RESP;
    	endmethod
    endinterface
endmodule

(* synthesize *)
module mkPatmos (Patmos);
    PatmosL0 core <- mkPatmosL0();
    Reg#(Bool) hold <- mkReg(True);
    
    BluetreeClient pat_tree <- mkPatmosTreeClient(core.burst);
    
    rule hold_reset(hold);
	core.hold();
    endrule
    
    method Action start();
	hold <= False;
    endmethod
    
    interface client = pat_tree;
endmodule

endpackage