//----------------------------------- This is the top module of the UART tx ---------------------------//
//-----------------------------------------------------------------------------------------------------//

module uart_transmitter
(
input  [7:0]tx_data,
input       tx_start,
input       start_bit,
input       stop_bit,
input       clk,
input       reset,
output      tx_busy,
output      tx_data_out
);

wire [1:0]select;
wire  load,shift ,slow_baud_clk,fast_baud_clk,data_bit,parity_bit;
wire  [3:0]muxin;

assign muxin = {stop_bit,parity_bit,data_bit,start_bit};

 baud_rate_generator a2(
      .clk(clk),
      .reset(reset),
      .baud_clk_fast(fast_baud_clk),
      .baud_clk_slow(slow_baud_clk)
	 );

tx_fsm a1 
(.tx_start(tx_start),
.reset(reset),
.start_bit(start_bit),
.stop_bit(stop_bit),
.slow_baud_clk(slow_baud_clk),
.fast_baud_clk(fast_baud_clk),
.tx_busy(tx_busy),
.select(select),
.load(load),
.shift(shift)
);

piso_uart a3 (
   .tx_data(tx_data),
   .slow_baud_clk(slow_baud_clk),
   .shift(shift),
   .load(load),
   .reset(reset),
   .data_bit(data_bit)
);

parity_generator a4
(
      .tx_data(tx_data),
      .load(load),  // it is useless but making according to the diagram
      .parity_bit(parity_bit)

);

uart_mux a5
(
     .data_in(muxin),
     .select(select),
     .tx_data_out(tx_data_out)
);


endmodule