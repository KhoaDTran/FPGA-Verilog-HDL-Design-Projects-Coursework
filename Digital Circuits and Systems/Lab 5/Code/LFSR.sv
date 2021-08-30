//Khoa Tran
//08/05/2020
//Lab 5
//This module implements a sequential circuit that acts as a shift register
//that shifts the binary values to the right. This module implements
//a 10-bit LFSR that shifts values to the right in order to output
//all possible 10-bit binary number. This module shift values at the
//positive clock edge and allows for reset to revert the output back to
//10-bit binary of 0. Lastly, test the output at positive clockedge.

//Implements LFSR module with input reset and clk. The output variable
//is out which outputs the value of out due to either the shifting or
//reset being called. Reset allows for out to revert back to 0, while
//out shifts 1-bit to the right at every positive clock edge to produce
//all possible 10-bit binary values.
module LFSR (clk, reset, out);
	input logic clk, reset;
	output logic [9:0] out;
	always_ff @(posedge clk) 
		begin
			if (reset)
				out <= 10'b0000000000;
			else begin
				out <= out>>1;
				out[9] <= ~(out[0] ^ out[3]);
			end
		end
	endmodule

//Module test the output of the LFSR module by running a sequence of 
//positive clock edge to test if the output, out, is correct along
//the positive edges, by making sure out shifts by 1-bit to the right.
module LFSR_testbench();

		logic reset, clk;
		logic [9:0] out;
		
		LFSR dut (.clk, .reset, .out);
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end //initial
		
		initial begin
		
			reset <= 1;		@(posedge clk);
			reset <= 0; 	@(posedge clk);
								@(posedge clk);	
								@(posedge clk);	
								@(posedge clk);	
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								@(posedge clk);
			$stop; //end simulation							
							
		end //initial
		
endmodule
