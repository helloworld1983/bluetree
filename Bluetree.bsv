// Membership: Bluetree (all)
// Purpose: Definitions of Bluetree
// This also contains the canonical Bluetree router.
// TODO: Factor the router out into BluetreeMux2 at some point.
package Bluetree;

export BluetreeClient(..);
export BluetreeServer(..);
export BluetreeTaskId;
export BluetreeCPUId;
export BluetreeData;
export BluetreeBEN;
export BluetreeAddress;
export BluetreeBlockAddress;
export BluetreeByteAddress;
export BluetreeWordAddress;
export BluetreeBurstCounter;
export BluetreePriority;
export BluetreeServerPacket(..);
export BluetreeClientPacket(..);
export BluetreeMessageType(..);
export BluetreeClientMessageType(..);

export mkBluetreeMux2; 
export IfcBluetreeMux2(..);

export bluetreeBlockSize;
export bluetreeDataSize;
export bluetreeBlockAddressSize;
export bluetreeByteAddressSize;
export bluetreeWordAddressSize;
export bluetreeAddressSize;
export bluetreeBENSize;
export bluetreeBurstCounterSize;
export bluetreePrioritySize;

import GetPut::*;
import ClientServer::*;
import DReg::*;
import FIFO::*;
import BluetreeConfig::*;

typedef SizeOf#(BluetreeData) DataSize;
Integer bluetreeDataSize = valueOf(DataSize);

typedef SizeOf#(BluetreeBEN) BENSize;
Integer bluetreeBENSize = valueOf(BENSize);

typedef SizeOf#(BluetreeBlockAddress) BlockAddressSize;
Integer bluetreeBlockAddressSize = valueOf(BlockAddressSize);

typedef SizeOf#(BluetreeByteAddress) ByteAddressSize;
Integer bluetreeByteAddressSize = valueOf(ByteAddressSize);

typedef SizeOf#(BluetreeWordAddress) WordAddressSize;
Integer bluetreeWordAddressSize = valueOf(WordAddressSize);

typedef SizeOf#(BluetreeAddress) AddressSize;
Integer bluetreeAddressSize = valueOf(AddressSize);

Integer bluetreeBlockSize = bluetreeBENSize;

typedef SizeOf#(BluetreeBurstCounter) BurstCounterSize;
Integer bluetreeBurstCounterSize = valueOf(BurstCounterSize);

typedef SizeOf#(BluetreePriority) PrioritySize;
Integer bluetreePrioritySize = valueOf(PrioritySize);

// BT_MEM_SCHEDULED is to notify multiplexors of which CPU has been scheduled.
typedef enum {BT_READ = 0, BT_BROADCAST, BT_PREFETCH, BT_WRITE_ACK, BT_AXI_PROBE, BT_SQUASH, BT_MEM_SCHEDULED}
            BluetreeMessageType deriving (Bits, Eq);

// Standard = normal mem request. Prefetch is to signify a prefetch packet and is currently largely
// unused. Prefetch hit denotes that a prefetched packet was hit and so another prefetch should be generated.
// BT_AXI_PROBE is used for sending a command to the AXI bus.
typedef enum {BT_STANDARD = 0, BT_PREFETCH, BT_PREFETCH_HIT, BT_AXI_PROBE}
            BluetreeClientMessageType deriving (Bits, Eq);

typedef struct {
    BluetreeClientMessageType   message_type;
    BluetreeData                data;
    BluetreeBEN                 ben;
    BluetreeBlockAddress        address;
    BluetreeTaskId              task_id;
    BluetreeCPUId               cpu_id;
    BluetreePriority            prio;
    BluetreeBurstCounter        size;
} BluetreeClientPacket deriving (Bits, Eq);

typedef struct {
    BluetreeMessageType     message_type;
    BluetreeData            data;
    BluetreeBlockAddress    address;
    BluetreeTaskId          task_id;
    BluetreeCPUId           cpu_id;
} BluetreeServerPacket deriving (Bits, Eq);

typedef Client#(BluetreeClientPacket, BluetreeServerPacket) BluetreeClient;
typedef Server#(BluetreeClientPacket, BluetreeServerPacket) BluetreeServer;

// Interfaces for handshake clients/servers. These can be connected together, or to standard Client/Server
// interfaces using mkConnection as usual.
//typedef ClientCommit#(BluetreeClientPacket, BluetreeServerPacket) BluetreeCommitClient;
//typedef ServerCommit#(BluetreeClientPacket, BluetreeServerPacket) BluetreeCommitServer;

interface IfcBluetreeMux2;
    interface BluetreeClient client;
    interface BluetreeServer server0;
    interface BluetreeServer server1;
endinterface


(* synthesize *)
module mkBluetreeMux2 (IfcBluetreeMux2);
    Reg#(BluetreeServerPacket) down <- mkReg(unpack(0));
    FIFO#(BluetreeClientPacket) up <- mkFIFO(); 
    FIFO#(BluetreeClientPacket) in0 <- mkFIFO(); 
    FIFO#(BluetreeClientPacket) in1 <- mkFIFO(); 
    Reg#(Bool) down_valid_0 <- mkDReg(False);
    Reg#(Bool) down_valid_1 <- mkDReg(False);
    BluetreeCPUId broadcast = unpack(-1);
    
//    PulseWire set_down_valid_0 <- mkPulseWire();
//    PulseWire reset_down_valid_0 <- mkPulseWire();
//    PulseWire set_down_valid_1 <- mkPulseWire();
//    PulseWire reset_down_valid_1 <- mkPulseWire();
    
    Reg#(int) ticks <- mkReg(0);
    
    // Data received in upwards direction (towards memory)
    (* descending_urgency = "relay_up_0, relay_up_1" *)
    rule relay_up_0;
        BluetreeClientPacket b = in0.first();
        if (b.cpu_id != broadcast) begin
            b.cpu_id = (b.cpu_id << 1) | 0;
        end
        in0.deq();
        up.enq(b);
    endrule

    rule relay_up_1;
        BluetreeClientPacket b = in1.first();
        if (b.cpu_id != broadcast) begin
            b.cpu_id = (b.cpu_id << 1) | 1;
        end
        in1.deq();
        up.enq(b);
    endrule
    
    rule tick;
	   ticks <= ticks + 1;
    endrule
    
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
        interface request = toGet(up);
    endinterface
    interface BluetreeServer server0;
        interface Get response;
            method ActionValue#(BluetreeServerPacket) get() if (down_valid_0);
                return down;
            endmethod
        endinterface

        interface request = toPut(in0);
    endinterface
    interface BluetreeServer server1;
        interface Get response;
            method ActionValue#(BluetreeServerPacket) get() if (down_valid_1);
                return down;
            endmethod
        endinterface
        
        interface request = toPut(in1);
    endinterface
endmodule


endpackage
