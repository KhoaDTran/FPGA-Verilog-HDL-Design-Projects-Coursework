//Khoa Tran
//08/05/2020
//Lab 5
//This module implements a sequential circuit that acts as a register
//that goes through a specific state sequence. In this module, it is a
//counter that has a specific n-bit size, and counts from 0 to 2^(n-1)
//in binary. This module counts upwards at positive clock edge. This 
//module allows reset to make the output go back to 0 when reset is called 
//or when the other player hits the value of 7. As the counter's count
//increase, the display outputs the 7-bit binary output for the HEX board
//displaying the current digital value. When the binary value equals 7,
//the temp outputs true in order to reset the game.
//Lastly, test the output at positive clockedge with various incr values.

//Implements counter module with input incr, reset, clk, display, other, and temp
//along with a parameter to initialize the n-bit size desired. The output variable
//is out which outputs the current count in binary as incr is on for the
//output to increment by 1. This module counts from 0 to 2^(n-1)
//in binary and counts upwards at positive clock edge. This 
//module allows reset to make the output go back to 0 when reset is called 
//or when the other player hits the value of 7. As the counter's count
//increase, the display outputs the 7-bit binary output for the HEX board
//displaying the current digital value. When the binary value equals 7,
//the temp outputs true in order to reset the game.
module counter #(parameter width = 3) (incr, reset, clk, display, other, temp);
	logic [width - 1: 0] out;
	input logic incr, reset, clk;
	output logic [6:0] display;
	output logic temp;
	input logic other;
	
	always_ff @(posedge clk)
	begin
		if (reset || other || temp)
			out <= 0;
		else if (incr)
			out <= out + 1;
	end
	
	always_comb begin
		case (out)
			3'b000: begin
						display = 7'b1000000;
						temp = 0;
						end
			3'b001: begin
						display = 7'b1111001;
						temp = 0;
						end
			3'b010: begin
						display = 7'b0100100;
						temp = 0;
						end
			3'b011: begin
						display = 7'b0110000;
						temp = 0;
						end
			3'b100: begin
						display = 7'b0011001;
						temp = 0;
						end
			3'b101: begin
						display = 7'b0010010;
						temp = 0;
						end
			3'b110: begin
						display = 7'b0000010;
						temp = 0;
						end
			3'b111: begin
						display = 7'b1111000;
						temp = 1;
						end
			default: begin
						display = 7'b1111111;
						temp = 0;
						end
		endcase
	end
	
endmodule

//Module test the output of the counter module by running a sequence of inputs
//on reset and incr to test if the output, display, other, and temp, is correct along
//the positive edges, by making sure out counts up by 1 when incr is 1.
module counter_testbench#(parameter width = 3)();

		logic incr, reset, clk, other, temp;
		logic [6:0] display;
		logic [width - 1:0] out;
		
		counter dut (.incr, .reset, .clk, .display, .other, .temp);
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end //initial
		
		initial begin
		
			reset <= 1;         		@(posedge clk);
			reset <= 0; incr<=0; 	@(posedge clk);
							incr<=1;	  	@(posedge clk);
							incr<=1;	  	@(posedge clk);
							incr<=1;	  	@(posedge clk);
							incr<=1;	  	@(posedge clk);
							incr<=0;	  	@(posedge clk);
							incr<=1;	  	@(posedge clk);
							incr<=1;	  	@(posedge clk);
							incr<=1;	  	@(posedge clk);	
											@(posedge clk);	
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
			$stop; //end simulation							
							
		end //initial
		
endmodule
