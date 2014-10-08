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

package ToplevelBT;
import GetPut::*;
import Connectable::*;
import FIFO::*;
import ClientServer::*;
import Bluetree::*;
import BluetreeProxy::*;
import Clocks::*;
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

interface IfcToplevelBT;
    interface BluetreeClient client;
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
module mkToplevelBT (Clock mem_clock, Reset mem_resetn, IfcToplevelBT ifc);
    // Bluetree tree structure
    IfcBluetreeMux2 mux[`XPMC_NODES];
    Integer i;
    for (i = 0; i < `XPMC_NODES; i = i + 1) begin
//        mux[i] <- mkBluetreeMux2();
          mux[i] <- mkBluetreeFlipMux2(2, False, False);
    end
    
    Vector#(`CPUS, BluetreeClient) proc_bt_clients;
    Vector#(`CPUS, IfcBluetreeToOCP) bridges;
    Vector#(`CPUS, OcpBurstSlave) slaves;
  
    // CPUs
    for (i = 0; i < `CPUS; i = i + 1) begin
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
    
    // External links
    interface procs = slaves;
    interface client = pclient;
endmodule

endpackage
