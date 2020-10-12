module piso_uart 
(
input   [7:0]tx_data,
input   slow_baud_clk,
input   shift,
input   load,
input   reset,
output  data_bit
);

reg [7:0] tx_temp;


always @(posedge slow_baud_clk,negedge reset)
begin
       if(!reset)
          tx_temp <= 8'b0;
        
	 
         else if (load)
             tx_temp <= tx_data;
			 
         else if (shift ) 
             tx_temp <= {1'b0,tx_temp[7:1]};	 

    
end

assign data_bit = tx_temp[0];
endmodule