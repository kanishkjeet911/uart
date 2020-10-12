// Baud generator -- I will be using 20 MHz clk in the circuit and baud rate of 9600 -----//
 module baud_rate_generator (
 input     clk,
 input     reset,
 output     baud_clk_fast,
 output    baud_clk_slow  );
 
 
 parameter baud= 27'd9600;
 parameter clk_for_calculation = 27'd 20000000;
 parameter fast = (clk_for_calculation/(16*baud));
 parameter slow = fast*16;
 
reg  [7:0]counter,counter2  ;   //  20mhz/(16*9600) = 130 -> which means 130 clk cycles will be equal to the 1 clk cycle of baud_clk_fast and but we want only posege therfore 130/2 = 65.10
                       // that is why we need 6 bits to count till 65
//reg  [15:0] fast_reg,slow_reg;

always @ (posedge clk or negedge reset)
begin
if(!reset)
begin
counter <= 0;
counter2 <=0;
/*slow_reg<= 0;
fast_reg<= 0;*/
end

else if (counter > 130)
counter <= 0;
else if (counter2 > 208)
counter2 <= 0;
else
begin
counter <= counter + 1;
counter2 <= counter2 + 1;
/*slow_reg<= slow;
fast_reg<= fast;*/
end

end

assign baud_clk_slow =(counter > 65)?1:0;
assign baud_clk_fast = ( counter >104)?1:0;

endmodule
