//Khoa Tran
//07/24/2020
//Lab 4
//This module implements a D-flip-flop, which takes in an input
//of d1 as well as a clock, and a reset. This module outputs to q2
//and test wheter the input from d1 matches with q2 after the clock
//cycle as well as having the ability to reset and start over again.
//The input progresses on the positive clock edge.

//Implementing the meta module, which is a D-flip flop that takes in the inputs
//of clk, reset, d1. The output, q2, operates with a delay from the input by one clock
//cycle. The module also allows for the ability to reset and restart the input
//from the initial state. Lastly, the module
//progress to the next input value when clk is a positive edge.

module meta (clk, reset, d1, q2);

	input  logic  clk, reset, d1;
	logic q1;
	output logic  q2;
	
	//sequential logic (DFFs)
		always_ff @(posedge clk) begin
			if (reset)
				begin
				q1 <= 0;
				q2 <= 0;
				end
			else
				begin
				q1 <= d1;
				q2 <= q1;
				end
		end
	
endmodule


//Module test the output of the meta module by running a sequence of inputs
//on d1 and testing if the output, q2, is correct after a clock cycle of
//delay from the input as it progresses on the positive clock edge.
module meta_testbench();

		logic clk, reset, d1, q2;
		
		meta dut (.clk, .reset, .d1, .q2);
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end //initial
		
		initial begin
		
			reset <= 1;         @(posedge clk);
			reset <= 0; d1<=0;  @(posedge clk);
									  @(posedge clk);
			                    @(posedge clk);	
			            d1<=1;  @(posedge clk);
							d1<=1;  @(posedge clk);	
							d1<=0;  @(posedge clk);	
							d1<=1;  @(posedge clk);	
									  @(posedge clk);	
			                    @(posedge clk);	
			                    @(posedge clk);	
							d1<=0;  @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);
							d1<=0;  @(posedge clk);	
							d1<=0;  @(posedge clk);	
							d1<=1;  @(posedge clk);	
									  @(posedge clk);
									  @(posedge clk);
			$stop; //end simulation							
							
		end //initial
endmodule	