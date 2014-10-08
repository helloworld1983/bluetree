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


package PrioritySetReset;

export IfcPrioritySR(..);
export mkPrioritySR;

interface IfcPrioritySR#(type data);
    method data _read();
    method Action _write(data a);
    method Action reset();
endinterface

module mkPrioritySR#(data resetVal) (IfcPrioritySR#(data))
    provisos(Bits#(data, data_sz)); // Make sure we can actually represent it...
    
    RWire#(data) setWire   <- mkRWire();
    PulseWire    resetWire <- mkPulseWire();
    Reg#(data)   dataReg   <- mkReg(resetVal);
    
    (* no_implicit_conditions *)
    (* fire_when_enabled *)
    rule updateReg(isValid(setWire.wget) || resetWire);
    	if(isValid(setWire.wget))
    	    dataReg <= fromMaybe(unpack(0), setWire.wget());
    	else // Reset *must* be asserted
    	    dataReg <= resetVal;
    endrule
    
    method data _read();
	   return dataReg;
    endmethod
    
    method Action _write(data x);
	   setWire.wset(x);
    endmethod
    
    method Action reset();
	   resetWire.send();
    endmethod
endmodule

endpackage