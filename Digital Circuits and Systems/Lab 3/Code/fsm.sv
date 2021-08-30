//Khoa Tran
//07/14/2020
//Lab 3
//This module implements a string recognizer for the string 1101. Through the input W,
//the module detects for the pattern 1101 in order to output 1 for a one-bit value
//in the varible out. The module is able to reset to restart the string sequence. Also,
//waits for the positive clock edge in order to progress onto the input value. 

//Implementing the fsm module with the inputs clk, reset, w. The out variable outputs
//1 as a one-bit number when the sequence 1101 is detected with the input W. This fsm
//module allows for reset to start the input sequence all over again. Lastly, the module
//progress to the next input value when clk is a positive edge.

module fsm (clk, reset, w, out);

	input  logic  clk, reset, w;
	output logic  out;

	enum {S0, S1, S2, S3} ps, ns; // Present state, next state

	//Next state logic
	always_comb begin
		case (ps)
			S0: if (w) ns = S1;
					else ns = S0;
			S1: if (w) ns = S2;
					else ns = S0;
			S2: if (w) ns = S2;
					else ns = S3;
			S3: if (w) ns = S1;
					else ns = S0;
		endcase
	end
			
	assign out = (ps == S3) & w;  //use this statement or the next one
	//assign out = ps[1] & w;
	
	//sequential logic (DFFs)
		always_ff @(posedge clk) begin
			if (reset)
				ps <= S0;
			else
				ps <= ns;
		end
				
	
endmodule


//Module test the output of the fsm module by running a sequence of inputs
//on w and testing if the output, out, is correct.
module fsm_testbench();

		logic clk, reset, w, out;
		
		fsm dut (.clk, .reset, .w, .out);
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end //initial
		
		initial begin
		
			reset <= 1;         @(posedge clk);
			reset <= 0; w<=0;   @(posedge clk);
									  @(posedge clk);
			                    @(posedge clk);	
			                    @(posedge clk);	
			            w<=1;   @(posedge clk);
							w<=1;   @(posedge clk);	
							w<=0;   @(posedge clk);	
							w<=1;   @(posedge clk);	
									  @(posedge clk);	
			                    @(posedge clk);	
			                    @(posedge clk);	
							w<=0;   @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);
							w<=1;   @(posedge clk);	
							w<=1;   @(posedge clk);
							w<=0;   @(posedge clk);	
							w<=1;   @(posedge clk);	
									  @(posedge clk);
									  @(posedge clk);
			$stop; //end simulation							
							
		end //initial
		
endmodule		