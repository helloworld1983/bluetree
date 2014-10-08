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

