module parity_generator 
(
 input  [7:0] tx_data,
 input        load,  // it is useless but making according to the diagram
 output       parity_bit

);

assign parity_bit = ^tx_data;

endmodule
