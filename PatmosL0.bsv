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

package PatmosL0;

export OcpResp(..);
export OcpCmd(..);
export OcpData;
export OcpAddr;
export OcpBE;
export OcpBurstMaster(..);
export OcpCoreMaster(..);
export OcpBurstSlave(..);
export OcpBurstBridge(..);
export PatmosL0(..);
export mkPatmosL0;
export mkOcpBurstBridge;

`define DATA_WIDTH 32
`define ADDR_WIDTH 32
`define BE_WIDTH 4

typedef enum {
   ORESP_IDLE = 'b00,
   ORESP_DVA = 'b01,
   ORESP_FAIL = 'b10,
   ORESP_ERR = 'b11 
} OcpResp deriving (Bits, Eq);

// So...why have we defined RDEX and RDL, then stopped.
// They're just to pad the enum out to the required 3 bits.
typedef enum {
   OCMD_IDLE = 'b000,
   OCMD_WR = 'b001,
   OCMD_RD = 'b010,
   OCMD_RDEX = 'b011,
   OCMD_RDL = 'b100
} OcpCmd deriving (Bits, Eq);

typedef Bit#(`DATA_WIDTH) OcpData;
typedef Bit#(`ADDR_WIDTH) OcpAddr;
typedef Bit#(`BE_WIDTH) OcpBE;

// Consider moving all this to Ocp.bsv later
interface OcpBurstMaster;
    (* always_ready *)
    method OcpCmd get_MCmd();
    (* always_ready *)
    method OcpAddr get_MAddr();
    (* always_ready *)
    method OcpData get_MData();
    (* always_ready *)
    method Bit#(1) get_MDataValid();
    (* always_ready *)
    method OcpBE get_MBE();
    
    (* always_enabled *)
    (* always_ready *)
    method Action put_SResp(OcpResp resp);
    (* always_enabled *)
    (* always_ready *)
    method Action put_SData(OcpData data);
    (* always_ready *)
    method Action put_SCmdAccept();
    (* always_ready *)
    method Action put_SDataAccept();
endinterface

interface OcpBurstSlave;
    (* always_enabled *)
    method Action put_MCmd(OcpCmd x);
    (* always_enabled *)
    method Action put_MAddr(OcpAddr x);
    (* always_enabled *)
    method Action put_MData(OcpData x);
    (* always_ready *)
    method Action put_MDataValid();
    (* always_enabled *)
    method Action put_MBE(OcpBE x);
    
    (* always_ready *)
    method OcpResp get_SResp();
    (* always_ready *)
    method OcpData get_SData();
    (* always_ready *)
    method Bit#(1) get_SCmdAccept();
    (* always_ready *)
    method Bit#(1) get_SDataAccept();
endinterface

interface OcpCoreMaster;
    method OcpCmd get_MCmd();
    method OcpAddr get_MAddr();
    method OcpData get_MData();
    method OcpBE get_MBE();
    
    method Action put_SResp(OcpResp resp);
    method Action put_SData(OcpData data);
endinterface

interface PatmosL0;
    interface OcpBurstMaster burst;
    interface OcpCoreMaster core;
	
    method Action hold();
endinterface

interface OcpBurstBridge;
    interface OcpBurstMaster master;
    interface OcpBurstSlave slave;
endinterface

module mkOcpBurstBridge (OcpBurstBridge);
    Wire#(OcpCmd) cmd <- mkBypassWire();
    Wire#(OcpAddr) addr <- mkBypassWire();
    Wire#(OcpData) data <- mkBypassWire();
    PulseWire mDataValid <- mkPulseWire();
    Wire#(OcpBE) be <- mkBypassWire();
    
    // DWires to make the compiler just shut up.
    // For some reason it thinks they're not (* always_enabled *).
    // They are...
    Wire#(OcpResp) s_resp <- mkBypassWire();
    Wire#(OcpData) s_data <- mkBypassWire();
//    Wire#(OcpResp) s_resp <- mkBypassWire();
//    Wire#(OcpData) s_data <- mkBypassWire();
    PulseWire s_cmdAccept <- mkPulseWire();
    PulseWire s_dataAccept <- mkPulseWire();
    
    interface OcpBurstMaster master;
	method OcpCmd get_MCmd();
	    return cmd;
	endmethod
	
	method OcpAddr get_MAddr();
	    return addr;
	endmethod
	
	method OcpData get_MData();
	    return data;
	endmethod
	
	method Bit#(1) get_MDataValid();
	    return pack(mDataValid);
	endmethod
	
	method OcpBE get_MBE();
	    return be;
	endmethod
	
	method Action put_SResp(OcpResp resp);
	    s_resp <= resp;
	endmethod
	
	method Action put_SData(OcpData data);
	    s_data <= data;
	endmethod
	
	method Action put_SCmdAccept();
	    s_cmdAccept.send();
	endmethod
	
	method Action put_SDataAccept();
	    s_dataAccept.send();
	endmethod
    endinterface
    
    interface OcpBurstSlave slave;
	method Action put_MCmd(OcpCmd x);
	    cmd <= x;
	endmethod
	
	method Action put_MAddr(OcpAddr x);
	    addr <= x;
	endmethod
	
	method Action put_MData(OcpData x);
	    data <= x;
	endmethod

	method Action put_MDataValid();
	    mDataValid.send();
	endmethod
	
	method Action put_MBE(OcpBE x);
	    be <= x;
	endmethod
	
	method OcpResp get_SResp();
	    return s_resp;
	endmethod
	
	method OcpData get_SData();
	    return s_data;
	endmethod
	
	method Bit#(1) get_SCmdAccept();
	    return pack(s_cmdAccept);
	endmethod
	
	method Bit#(1) get_SDataAccept();
	    return pack(s_dataAccept);
	endmethod
    endinterface
endmodule


// YAY BVI :/
import "BVI" patmos_top = 
module mkPatmosL0 (PatmosL0);
    
    default_clock pat_clk;
    default_reset pat_rst;
    
    input_clock pat_clk (clk) <- exposeCurrentClock();
    input_reset pat_rst (rst_n) <- exposeCurrentReset();
    
    interface OcpBurstMaster burst;
	method io_mem_interface_M_Cmd get_MCmd();
	method io_mem_interface_M_Addr get_MAddr();
	method io_mem_interface_M_Data get_MData();
	method io_mem_interface_M_DataValid get_MDataValid();
	method io_mem_interface_M_DataByteEn get_MBE();
	
	method put_SResp(io_mem_interface_S_Resp) enable((* inhigh *)SRESP_ENABLE);
	method put_SData(io_mem_interface_S_Data) enable((* inhigh *)SDATA_ENABLE);
	method put_SCmdAccept() enable(io_mem_interface_S_CmdAccept);
	method put_SDataAccept() enable(io_mem_interface_S_DataAccept);
    endinterface
    
    interface OcpCoreMaster core;
	method io_comSpm_M_Cmd get_MCmd();
	method io_comSpm_M_Addr get_MAddr();
	method io_comSpm_M_Data get_MData();
	method io_comSpm_M_ByteEn get_MBE();
	
	method put_SResp(io_comSpm_S_Resp) enable((* inhigh *)SRESP_ENABLE2);
	method put_SData(io_comSpm_S_Data) enable((* inhigh *)SDATA_ENABLE2);
    endinterface

    method hold() enable(hold);
	    
    // Scheduling attrs
    // I hate doing these :/
    // Put methods can only be called once per cycle
    schedule burst.put_SResp C burst.put_SResp;
    schedule burst.put_SData C burst.put_SData;
    schedule burst.put_SCmdAccept C burst.put_SCmdAccept;
    schedule burst.put_SDataAccept C burst.put_SDataAccept;
    
    schedule core.put_SResp C core.put_SResp;
    schedule core.put_SData C core.put_SData;
    
    schedule hold C hold;
	
    // None of the GET methods conflict (they can't...there's no enables)
    schedule burst.put_SResp CF (burst.put_SData, burst.put_SCmdAccept, burst.put_SDataAccept, core.put_SResp, core.put_SData, hold);
    schedule burst.put_SData CF (burst.put_SResp, burst.put_SCmdAccept, burst.put_SDataAccept, core.put_SResp, core.put_SData, hold);
    schedule burst.put_SCmdAccept CF (burst.put_SData, burst.put_SResp, burst.put_SDataAccept, core.put_SResp, core.put_SData, hold);
    schedule burst.put_SDataAccept CF (burst.put_SData, burst.put_SCmdAccept, burst.put_SResp, core.put_SResp, core.put_SData, hold);

    schedule core.put_SResp CF (burst.put_SData, burst.put_SCmdAccept, burst.put_SDataAccept, burst.put_SResp, core.put_SData, hold);
    schedule core.put_SData CF (burst.put_SData, burst.put_SCmdAccept, burst.put_SDataAccept, core.put_SResp, burst.put_SResp, hold);
    schedule hold CF (burst.put_SData, burst.put_SCmdAccept, burst.put_SDataAccept, core.put_SResp, core.put_SData, burst.put_SResp);
	
    // All gets don't conflict with each other
    schedule (burst.get_MCmd, burst.get_MAddr, burst.get_MData, burst.get_MDataValid, burst.get_MBE, 
	      core.get_MCmd, core.get_MAddr, core.get_MData, core.get_MBE) CF
             (burst.get_MCmd, burst.get_MAddr, burst.get_MData, burst.get_MDataValid, burst.get_MBE, 
	      core.get_MCmd, core.get_MAddr, core.get_MData, core.get_MBE);
    
    // The gets and sets don't clash with each other (or rather, shouldn't).
    // This is needed because the Bluetiles client can read a cmd while writing a response.
    schedule (burst.get_MCmd, burst.get_MAddr, burst.get_MData, burst.get_MDataValid, burst.get_MBE, 
	      core.get_MCmd, core.get_MAddr, core.get_MData, core.get_MBE) CF
             (burst.put_SResp, burst.put_SData, burst.put_SCmdAccept, burst.put_SDataAccept,
	      core.put_SResp, core.put_SData, hold);
endmodule

    
endpackage