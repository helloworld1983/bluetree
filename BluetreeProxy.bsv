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

