module uart_mux
(
input  [3:0]data_in,
input  [1:0]select,
output reg      tx_data_out
);

always @(*)
begin
  case (select)
     2'b00 : tx_data_out <= data_in[0];
	 2'b01 : tx_data_out <= data_in[1];
	 2'b10 : tx_data_out <= data_in[2];
	 2'b11 : tx_data_out <= data_in[3];
	 //default : tx_data_out <= 1'bz;

   endcase
end
endmodule
  