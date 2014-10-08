// Copyright 2014 University of York
// All rights reserved.
// 
// This file is part of the Bluetree memory tree.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
//   1. Redistributions of source code must retain the above copyright notice,
//      this list of conditions and the following disclaimer.
//   2. Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ‘‘AS IS’’ AND ANY EXPRESS
// OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
// NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// 
// The views and conclusions contained in the software and documentation are
// those of the authors and should not be interpreted as representing official
// policies, either expressed or implied, of the copyright holder.


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