module tx_fsm
( input        tx_start,
  input        reset,
  input        start_bit,
  input        stop_bit,
  input        fast_baud_clk,
  input        slow_baud_clk,
  output reg   tx_busy,
  output reg   [1:0]select,
  output reg   load,
  output reg   shift
);
parameter  idle = 3'b000 ;
parameter start_bit_state = 3'b001 ;
parameter Data_acception = 3'b010 ;
parameter parity_gen = 3'b011 ;
parameter stop_bit_state = 3'b100 ;

 reg  [2:0] state ;
 reg  [2:0]next_state;
 
reg [29:0]count,end_count;
reg [3:0]data_count; // for counting  the data bits


//***************************************************** combinational logic********************************************************//
always @ (tx_start,start_bit,stop_bit,posedge slow_baud_clk)
begin
case(state)
//-----------------idle state begins ------------------------//
idle : begin
     load <= 1'bz;
     shift<= 1'bz;
     tx_busy = 1 ;
     select = 2'bz;
	 
     if(tx_start)

           next_state <= start_bit_state;



/*else
    next_state <= idle;*/
end

//-------------------- idle state ends ---------------------//

//-------------------- start_bit state begins ---------------------//
start_bit_state :

begin
     load <= 1'bz;
     shift<= 1'bz;
     tx_busy = 1 ;
     select = 2'b00;
      
	 if((slow_baud_clk == 1'b1) && (start_bit == 1'b1) && (count < 30'd5))
	     count <= count + 1 ;  //counting 30  clock pulses so as to check if  start bit is not a glitch
     if (count == 30'd4)
	      begin
            next_state <= Data_acception;
            count <= 30'd0 ;
		  end
	

/*
else
    next_state <= idle ; //we are having a glitch*/


end
//-------------------- start_bit state ends ---------------------//

//-------------------- Data_acception state begin ---------------------//
Data_acception :
begin
    
     //select = 2'b01;
	 //load <= 1;
     //shift<= 1;
     tx_busy = 1 ;
     //select = 2'b01;
	 
	 if (slow_baud_clk)
	  begin
	      data_count <= data_count + 1;
	  end
	  
	  if(data_count == 1)
	   begin
	        load <= 1'b1;
			shift <= 1'bz;
	   end
	   
	  if(data_count == 3 )
	    begin
		   select <= 2'b01;
		   load <= 1'bz;
		   shift <= 1'b1;
		end
		
	  if (data_count == 10)
	  begin
	       load  <= 1'bz;
		   shift <= 1'bz;
		   select <= 2'b01;
		   next_state <= parity_gen;
           data_count <= 4'b0;

	  end



end
//-------------------- Data_acception state ends ---------------------//

//---------------------- Parity_gen state begins-------------------------//
parity_gen:
begin
    select <= 2'b10;
    next_state <= stop_bit_state;
    load <= 1;
    shift <= 1'bz;
    tx_busy <= 1; 


end

//---------------------- Parity_gen state ends-------------------------//

//---------------------- stop_bit state begins-------------------------//
stop_bit_state :

begin
     load <= 1'bz;
     shift<= 1'bz;
     tx_busy = 1 ;
     select = 2'b11;
	 
	 if((slow_baud_clk == 1) && (stop_bit == 1) && (end_count < 30'd5))
	     end_count <= end_count + 1 ;  //counting 30  clock pulses so as to check if  start bit is not a glitch
     if (end_count == 30'd4)
	      begin
            next_state <= idle;
            end_count <= 30'd0 ;     //************************to use fast clock we have to sample the slow_baud_clk at its posedge and use its impulse bus in Data_acception label:1*****//
		  end
	 
	 
	 

end

default :
begin
next_state <= idle;
end

endcase

end
//**************************************************end of combinational Logic********************************************************//

//**************************************************Sequential Logic begins *********************************************************//


always @ (posedge slow_baud_clk)
begin
      if(!reset)
	  begin
	             state <= idle;
				 count <= 30'b0;
				 end_count <= 30'b0;
				 data_count <= 4'b0;
	  end
	  else
	      state <= next_state;
end

endmodule