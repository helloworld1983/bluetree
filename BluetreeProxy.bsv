// A clock domain crossing, wrapped up nicely in a Bluetree client/server method.
package BluetreeProxy;

import Bluetree::*;
import FIFO::*;
import FIFOF::*;
import Clocks::*;
import GetPut::*;
import ClientServer::*;

module mkBluetreeProxy#(BluetreeClient bs_client) (
                    Clock ram_client_clk, 
                    Reset ram_client_resetn, 
                    BluetreeClient proxy);

	SyncFIFOIfc#(BluetreeClientPacket) to_bs_client <- mkSyncFIFOFromCC(2, 
                    ram_client_clk);
	SyncFIFOIfc#(BluetreeServerPacket) from_bs_client <- mkSyncFIFOToCC(2, 
                    ram_client_clk, ram_client_resetn);

    rule get_from;
        BluetreeClientPacket s <- bs_client.request.get();
        to_bs_client.enq(s);
    endrule

    rule put_to;
        BluetreeServerPacket c = from_bs_client.first();
        from_bs_client.deq();

        bs_client.response.put(c);
    endrule

    interface response = toPut(from_bs_client);
    interface request = toGet(to_bs_client);
endmodule

endpackage

