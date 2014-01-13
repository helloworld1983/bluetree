Bluetree
========

Bluetree is the time-predictable memory NoC. This takes a tree form, with *n* processors at the bottom of the tree, and
a single link to memory at the top of the tree. Each level of the tree is a 2-1 mux, with the left channel taking priority.

At the moment, this is built for a 16-processor system with an AXI bridge at the top of the tree. The top-level is mkToplevel.v,
which instantiates 15 bluetree instances (in mkBluetreeMux2.v) and connects them up, exposing the processor-side connections
and the memory-side connection as top-level ports.

Bluetree itself uses a 198/175-bit bus, carrying four data words at a time. At the moment, documentation on this format is not
publically available.

All the files contained here are required. mkBluetreeMux2.v instantiates an actual Bluetree multiplexor. mkAxiConn.v
converts a Bluetree connection to an AXI connection. FIFO2.v is a FIFO instance provided by Bluespec inc, which can be
publically distributed due to its license.

