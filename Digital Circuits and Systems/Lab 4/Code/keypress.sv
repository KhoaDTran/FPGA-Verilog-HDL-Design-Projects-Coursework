//Khoa Tran
//07/24/2020
//Lab 4
//This module implements a keypress that simulates the effect of holding a key for
//an input the same as pressing the key. This module follows state logic by forcing
//the input to be 1 and then 0 before outputing 1. This allows to create the effect of
//letting go of the button before the output register. 

//Implementing the keypress module with the inputs clk, reset, in. 
//The out variable outputs 1 as a one-bit number when the input goes from 1 to 0.
//This keypress module allows for reset to start the input sequence all over again. 
//Lastly, the module progress to the next input value when clk is a positive edge.

module keypress (clk, reset, in, out);

	input  logic  clk, reset, in;
	output logic  out;
	
	enum {S0, S1} ps, ns; // Present state, next state

	//Next state logic
	always_comb begin
		case (ps)
			S0: if (in) ns = S1;
					else 	ns = S0;
			S1: if (in) ns = S1;
					else 	ns = S0;
		endcase
	end
			
	assign out = (ps == S1) & (~in); 
	
	//sequential logic (DFFs)
		always_ff @(posedge clk) begin
			if (reset)
				ps <= S0;
			else
				ps <= ns;
		end
				
	
endmodule


//Module test the output of the keypress module by running a sequence of inputs
//on in as well as the reset and testing if the output, out, is correct along
//the positive edges.
module keypress_testbench();

		logic clk, reset, in, out;
		
		keypress dut (.clk, .reset, .in, .out);
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end //initial
		
		initial begin
		
			reset <= 1;         @(posedge clk);
			reset <= 0; in<=0;  @(posedge clk);
									  @(posedge clk);
			                    @(posedge clk);	
			                    @(posedge clk);	
			            in<=1;  @(posedge clk);
							in<=1;  @(posedge clk);	
							in<=0;  @(posedge clk);	
							in<=1;  @(posedge clk);	
									  @(posedge clk);	
			                    @(posedge clk);	
			                    @(posedge clk);	
							in<=0;  @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);
							in<=0;  @(posedge clk);	
							in<=0;  @(posedge clk);
							in<=1;  @(posedge clk);	
							in<=1;  @(posedge clk);
							in<=1;  @(posedge clk);
							in<=0;  @(posedge clk);
									  @(posedge clk);
									  @(posedge clk);
			$stop; //end simulation							
							
		end //initial
		
endmodule		