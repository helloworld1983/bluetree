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



package Toplevel;
import GetPut::*;
import Connectable::*;
import FIFO::*;
import ClientServer::*;
import Bluetree::*;
import BluetreeProxy::*;
import Clocks::*;
//import BRAMServer::*;
import BluetreeFlipMux2::*;

import Patmos::*;
import PatmosL0::*;
import Vector::*;
import AxiConn::*;
import Axi::*;

`include "Axi.defines"

`define WIDTH       5
`define HEIGHT      4
`define XPMC_NODES  15
`define CPUS        16

// Stolen from AxiConn.bsv - find a better way to do this.
`define MY_AXI_PRM_STD 4, 32, 128, 10, AxiCustom
`define MY_AXI_RR_STD TLMRequest#(`MY_AXI_PRM_STD), TLMResponse#(`MY_AXI_PRM_STD) 
`define MY_AXI_XTR_STD `MY_AXI_RR_STD, `MY_AXI_PRM_STD

interface IfcToplevel;
    interface AxiRdFabricMaster#(`MY_AXI_PRM_STD) axi_read;
    interface AxiWrFabricMaster#(`MY_AXI_PRM_STD) axi_write;
    interface Vector#(`CPUS, OcpBurstSlave) procs;
endinterface

interface IfcBluetreeToOCP;
    interface BluetreeClient bluetree;
    interface OcpBurstSlave  slave;
endinterface

(* synthesize *)
module mkBluetreeToOCP(IfcBluetreeToOCP);
    OcpBurstBridge bridge <- mkOcpBurstBridge();
    BluetreeClient client <- mkPatmosTreeClient(bridge.master);
    
    interface bluetree = client;
    interface slave = bridge.slave;
endmodule

(* synthesize *)
module mkToplevel (Clock mem_clock, Reset mem_resetn, IfcToplevel ifc);
    // Bluetree tree structure
    IfcBluetreeMux2 mux[`XPMC_NODES];
    Integer i;
    for (i = 0; i < `XPMC_NODES; i = i + 1) begin
        //mux[i] <- mkBluetreeMux2();
        mux[i] <- mkBluetreeFlipMux2(2, False, False); 
    end
    
//    Vector#(`CPUS, BluetreeClient) proc_bt_clients;
//    Vector#(`CPUS, OcpBurstBridge) bridges;
//    Vector#(`CPUS, OcpBurstSlave) slaves;
  
    Vector#(`CPUS, BluetreeClient) proc_bt_clients;
    Vector#(`CPUS, IfcBluetreeToOCP) bridges;
    Vector#(`CPUS, OcpBurstSlave) slaves;
  
    // CPUs
    for (i = 0; i < `CPUS; i = i + 1) begin
//	bridges[i] <- mkOcpBurstBridge();
//	slaves[i] = bridges[i].slave;
//	proc_bt_clients[i] <- mkPatmosTreeClient(bridges[i].master);
	
	bridges[i] <- mkBluetreeToOCP;
	slaves[i] = bridges[i].slave;
	proc_bt_clients[i] = bridges[i].bluetree;
    end

    // XPMC structure
   // Connect up the first 16 MBlazes
   Integer toCreate;
   Integer parent = 0;
   Integer baseId = 1;
   
   for(toCreate = 2; toCreate < 16; toCreate = toCreate * 2) begin
      for(i = 0; i < toCreate; i = i + 2) begin
	 mkConnection(mux[baseId + i + 0].client, mux[parent].server0);
	 mkConnection(mux[baseId + i + 1].client, mux[parent].server1);
	 
	 parent = parent + 1;
      end      
      baseId = baseId + toCreate;
   end
    
    // And the cpus...
   for(i = 0; i < 16; i = i + 2) begin
      // Now, parent should be pointing to the last row of Bluetree. Hopefully.
//      mkConnection(proc_bt_clients[i + 0], mux[parent].server0);
//      mkConnection(proc_bt_clients[i + 1], mux[parent].server1);
       
       mkConnection(mux[parent].server0, proc_bt_clients[i+0]);
       mkConnection(mux[parent].server1, proc_bt_clients[i+1]);
       
      parent = parent + 1;
   end
    
    BluetreeClient pclient <- mkBluetreeProxy(
                mux[0].client, mem_clock, mem_resetn);
    
    // Connect up the AXI bridge
    IfcAxiConn axi <- mkAxiConn(clocked_by mem_clock, reset_by mem_resetn);
    mkConnection(axi.server, pclient);
    
    // External links
    interface procs = slaves;
    interface axi_read = axi.axi_read;
    interface axi_write = axi.axi_write;
endmodule

endpackage
