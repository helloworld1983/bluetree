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


// The multiplexor as described in D4.5 for T-CREST.
// Will allow m-1 high-priority packets through before relinquishing
// control to a low-priority packet. THIS HAS ONLY BEEN SIMULATED FOR A TEST.
package BluetreeFlipMux2;

export mkBluetreeFlipMux2;

import Bluetree::*;
import GetPut::*;
import ClientServer::*;
import Connectable::*;
import FIFO::*;
import FIFOF::*;
import DReg::*;
import PrioritySetReset::*;

// slotMode dictates whether the mux relays prefetch slots (i.e. assumes always backlogged).
// detectHits dictates whether the mux will check for prefetch hit clashes.
module mkBluetreeFlipMux2#(UInt#(8) flipCycle, Bool slotMode, Bool detectHits) (IfcBluetreeMux2);
    // Down queue
    Reg#(BluetreeServerPacket) down <- mkReg(unpack(0));
    RWire#(BluetreeClientPacket) up <- mkRWire();
    RWire#(UInt#(1)) upDir <- mkRWire();

    IfcPrioritySR#(Maybe#(BluetreeClientPacket)) in0 <- mkPrioritySR(tagged Invalid);
    IfcPrioritySR#(Maybe#(BluetreeClientPacket)) in1 <- mkPrioritySR(tagged Invalid);

    PulseWire in0_done <- mkPulseWire();
    PulseWire in1_done <- mkPulseWire();

    //FIFOF#(BluetreeClientPacket) in0 <- mkGLFIFOF(True, True);
    //FIFOF#(BluetreeClientPacket) in1 <- mkGLFIFOF(True, True);

    Reg#(Bool) down_valid_0 <- mkDReg(False);
    Reg#(Bool) down_valid_1 <- mkDReg(False);
    PulseWire down0_is_prefetch_hit <- mkPulseWire();
    PulseWire down1_is_prefetch_hit <- mkPulseWire();

    BluetreeCPUId broadcast = unpack(-1);
    Reg#(int) ticks <- mkReg(0);

    Reg#(UInt#(8)) flipCounter <- mkReg(flipCycle - 1);

    PulseWire packetSent <- mkPulseWire();
    PulseWire fullyBacklogged <- mkPulseWire();

    // Helper reg...
    BluetreeClientPacket slotPkt = unpack(0);
    slotPkt.message_type = BT_PREFETCH;

    if(slotMode) begin
        // Emulate always backlogged if we're in slot mode...
        rule updateFullyBacklogged;
            fullyBacklogged.send();
        endrule
    end
    else begin
        rule updateFullyBacklogged(isValid(in0) && isValid(in1));
            fullyBacklogged.send();
        endrule
    end

    rule accounting(packetSent);
        //$display("FLIPMUX: Time %d flipCounter %d", $time(), flipCounter);
        if(fullyBacklogged) begin
            if(flipCounter == 0) // A LP packet will be issued
                flipCounter <= flipCycle - 1;
            else // HP packet will be issued
                flipCounter <= flipCounter - 1;
        end
        else // Reset.
            flipCounter <= flipCycle - 1;
    endrule

    rule reset_in0(in0_done);
        in0.reset();
    endrule

    rule reset_in1(in1_done);
        in1.reset();
    endrule

    // Data received in upwards direction (towards memory)
    // Given they can fire on either !fullyBacklogged or flipCounter ==/!= 0, they're
    // mutually exclusive. Or should be...
    (* mutually_exclusive = "relay_up_0, relay_up_1" *)
    rule relay_up_0 (!fullyBacklogged || flipCounter != 0);
        if(in0 matches tagged Valid .pkt) begin
            BluetreeClientPacket b = pkt;
            if (b.cpu_id != broadcast) begin
                b.cpu_id = (b.cpu_id << 1) | 0;
            end
            upDir.wset(0);
            up.wset(b);
            //$display("MUX: Up0: Enqueueing real packet");
        end
        else if(slotMode) begin
            //$display("MUX: Up0: No packet. Enqueueing slot.");
            up.wset(slotPkt);
            upDir.wset(0);
        end
    endrule

    rule relay_up_1 (!fullyBacklogged || flipCounter == 0);
        if(in1 matches tagged Valid .pkt) begin
            BluetreeClientPacket b = pkt;
            if (b.cpu_id != broadcast) begin
                b.cpu_id = (b.cpu_id << 1) | 1;
            end
            upDir.wset(1);
            up.wset(b);
            //$display("MUX: Up1: Enqueueing real packet");
        end
        else if(slotMode) begin
            //$display("MUX: Up1: No packet. Enqueueing slot.");
            up.wset(slotPkt);
            upDir.wset(1);
        end
    endrule
    
    rule tick;
       ticks <= ticks + 1;
    endrule

    if(detectHits) begin
        rule createHit0(in0 matches tagged Valid .pkt &&& down_valid_0);
            // For same CPUs                Prefetch is being returned          Upwards message is standard        And a read      And for the same address
            if(down.cpu_id == pkt.cpu_id && down.message_type == BT_PREFETCH && pkt.message_type == BT_STANDARD && pkt.ben == 0 && pkt.address == down.address) begin
                down0_is_prefetch_hit.send();
            end
        endrule

        rule createHit1(in1 matches tagged Valid .pkt &&& down_valid_1);
            // For same CPUs                Prefetch is being returned          Upwards message is standard        And a read      And for the same address
            if(down.cpu_id == pkt.cpu_id && down.message_type == BT_PREFETCH && pkt.message_type == BT_STANDARD && pkt.ben == 0 && pkt.address == down.address) begin
                down1_is_prefetch_hit.send();
            end
        endrule

        rule updateHit0(in0 matches tagged Valid .pkt &&& down0_is_prefetch_hit && !in0_done);
            BluetreeClientPacket new_pkt = pkt;
            new_pkt.message_type = BT_PREFETCH_HIT;
            in0 <= tagged Valid new_pkt;
            $display("FLIPMUX: Coaleasced side 0 with prefetch.");
        endrule

        rule updateHit1(in1 matches tagged Valid .pkt &&& down1_is_prefetch_hit && !in1_done);
            BluetreeClientPacket new_pkt = pkt;
            new_pkt.message_type = BT_PREFETCH_HIT;
            in1 <= tagged Valid new_pkt;
            $display("FLIPMUX: Coaleasced side 1 with prefetch.");
        endrule

        /*rule createHit0(in0 matches tagged Valid .pkt &&& down_valid_0 && !in0_done);
            if(down.cpu_id == pkt.cpu_id && down.message_type == BT_PREFETCH && pkt.message_type == BT_STANDARD && pkt.ben == 0 && pkt.address == down.address) begin
                BluetreeClientPacket new_pkt = pkt;
                new_pkt.message_type = BT_PREFETCH_HIT;
                in0 <= tagged Valid new_pkt;
                down0_is_prefetch_hit.send();
                $display("FLIPMUX: Coaleasced side 0 with prefetch.");
            end
        endrule

        rule createHit1(in1 matches tagged Valid .pkt &&& down_valid_1 && !in1_done);
            if(down.cpu_id == pkt.cpu_id && down.message_type == BT_PREFETCH && pkt.message_type == BT_STANDARD && pkt.ben == 0 && pkt.address == down.address) begin
                BluetreeClientPacket new_pkt = pkt;
                new_pkt.message_type = BT_PREFETCH_HIT;
                in1 <= tagged Valid new_pkt;
                down1_is_prefetch_hit.send();
                $display("FLIPMUX: Coaleasced side 1 with prefetch.");
            end
        endrule*/

        /*rule createHit((down_valid_0 || down_valid_1) && !in0_done && !in1_done);
            if(in0 matches tagged Valid .pkt &&& down_valid_0 && down.message_type == BT_PREFETCH) begin
                if(pkt.message_type == BT_STANDARD && pkt.ben == 0 && pkt.address == down.address) begin
                    BluetreeClientPacket new_pkt = pkt;
                    new_pkt.message_type = BT_PREFETCH_HIT;
                    in0 <= tagged Valid new_pkt;
                    down_is_prefetch_hit.send();
                end
            end
            else if(in1 matches tagged Valid .pkt &&& down_valid_1 && down.message_type == BT_PREFETCH) begin
                if(pkt.message_type == BT_STANDARD && pkt.ben == 0 && pkt.address == down.address) begin
                    BluetreeClientPacket new_pkt = pkt;
                    new_pkt.message_type = BT_PREFETCH_HIT;
                    in1 <= tagged Valid new_pkt;
                    down_is_prefetch_hit.send();
                end
            end
        endrule*/
    end
    
    interface BluetreeClient client;
        interface Put response;
            method Action put(BluetreeServerPacket b);
                if (b.cpu_id != broadcast) begin
                    if(b.cpu_id[0] == 0)
                        down_valid_0 <= True;
                    else
                        down_valid_1 <= True;
                    b.cpu_id = b.cpu_id >> 1;
                end 
                else begin
                    down_valid_0 <= True;
                    down_valid_1 <= True;
                end
                down <= b;
            endmethod
        endinterface
        interface Get request;
            method ActionValue#(BluetreeClientPacket) get() if(up.wget matches tagged Valid .x &&& upDir.wget matches tagged Valid .dir);
                BluetreeClientPacket pkt_tmp = x;
                if(dir == 0 && isValid(in0))
                    in0_done.send();
                else if(dir == 1 && isValid(in1))
                    in1_done.send();

                // Is it coaleasced with a prefetch?
                if((dir == 0 && down0_is_prefetch_hit) ||
                   (dir == 1 && down1_is_prefetch_hit)) begin
                    pkt_tmp.message_type = BT_PREFETCH_HIT;
                end

                packetSent.send();
                return pkt_tmp;
            endmethod
        endinterface
    endinterface
    interface BluetreeServer server0;
        interface Get response;
            method ActionValue#(BluetreeServerPacket) get() if (down_valid_0);
                BluetreeServerPacket down_tmp = down;

                if(down.message_type == BT_PREFETCH && down0_is_prefetch_hit) begin
                    down_tmp.message_type = BT_READ;
                    down_tmp.task_id = ~0;
                end

                return down_tmp;
            endmethod
        endinterface

        interface Put request;
            method Action put(BluetreeClientPacket pkt) if(!isValid(in0) || in0_done);
                in0 <= tagged Valid pkt;
            endmethod
        endinterface
    endinterface
    interface BluetreeServer server1;
        interface Get response;
            method ActionValue#(BluetreeServerPacket) get() if (down_valid_1);
                BluetreeServerPacket down_tmp = down;

                if(down.message_type == BT_PREFETCH && down1_is_prefetch_hit) begin
                    down_tmp.message_type = BT_READ;
                    down_tmp.task_id = ~0;
                end
                    
                return down_tmp;
            endmethod
        endinterface
        
        interface Put request;
            method Action put(BluetreeClientPacket pkt) if(!isValid(in1) || in1_done);
                in1 <= tagged Valid pkt;
            endmethod
        endinterface
    endinterface
endmodule

endpackage