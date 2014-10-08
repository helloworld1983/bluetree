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

// This package provides a mechanism for a dual ported variable, with
// either write capability, or reset capability. The write capability
// shadows the reset capability.
// Reset resets the value of this to resetVal, as specified in the parameters.
// Aside from the reset, this works exactly like a standard Reg#(data).
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