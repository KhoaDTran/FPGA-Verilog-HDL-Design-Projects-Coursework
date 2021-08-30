//Khoa Tran
//07/20/2020
//Lab 3
//This module implements a wind indicator by displaying the direction of the wind or
//its calmness. Through the input i0 and i1, the module detects the characteristic of
//the inputed wind conditions and outputs the correct pattern for the specific condition.
//The module is able to reset to restart the wind characteristic input. Also,
//waits for the positive clock edge in order to progress onto the input value. 

//Implementing the wind module with the inputs clk, reset, i0, and i1. The output variable 
//are out1, out2, and out3, which outputs the sequence that corresponds to the wind
//conditions. This wind module is implemented through state logics and 
//allows for reset to start the input sequence over again. Lastly, the module
//progress to the next input value when clk is a positive edge.

module wind (clk, reset, i0, i1, out1, out2, out3);

	input  logic  clk, reset, i0, i1;
	output logic  out1, out2, out3;

	//Following block is desgining state logic
	//ps = present state
	//ns = next state 
	//Depending on the present state(ps) and the inputs of
	//i0 and i1, it progresses onto a different state (ns)
	//from the conditions below.
	enum {S0, S1, S2, S3} ps, ns;

	//Next state logic
	always_comb begin
		case (ps)
			S0: if (i0 == 0 && i1 == 0) ns = S1;
					else if (i0 == 0 && i1 == 1) ns = S2;
					else ns = S3;
			S1: if (i0 == 0 && i1 == 0) ns = S0;
					else if (i0 == 0 && i1 == 1) ns = S3;
					else ns = S2;
			S2: if (i0 == 0 && i1 == 0) ns = S0;
					else if (i0 == 0 && i1 == 1) ns = S1;
					else ns = S3;
			S3: if (i0 == 0 && i1 == 0) ns = S0;
					else if (i0 == 0 && i1 == 1) ns = S2;
					else ns = S1;
		endcase
	end
			
	assign out1 = ((ps == S3) || (ps == S0));
	assign out2 = (ps == S1);
	assign out3 = ((ps == S2) || (ps == S0));
	
	//sequential logic (DFFs)
		always_ff @(posedge clk) begin
			if (reset)
				ps <= S0;
			else
				ps <= ns;
		end
				
	
endmodule


//Module test the output of the wind module by running a sequence of inputs
//on i0, and i1 in order to test different wind conditions and see if
//the outputs of ou1, out2, and out3 corresponds to the inputed wind conditions.
module wind_testbench();

		logic clk, reset, i0, i1, out1, out2, out3;
		
		wind dut (.clk, .reset, .i0, .i1, .out1, .out2, .out3);
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end //initial
		
		initial begin
		
			reset <= 1;         			@(posedge clk);
			reset <= 0; i0<=0; i1<=0;  @(posedge clk);
							i0<=0; i1<=0;	@(posedge clk);
												@(posedge clk);	
												@(posedge clk);	
			            i0<=0; i1<=1;  @(posedge clk);
							i0<=0; i1<=1;  @(posedge clk);	
							i0<=0; i1<=1;  @(posedge clk);		
												@(posedge clk);	
							i0<=1; i1<=0;	@(posedge clk);	
			            i0<=1; i1<=0;  @(posedge clk);	
							i0<=1; i1<=0;  @(posedge clk);	
												@(posedge clk);	
												@(posedge clk);	
												@(posedge clk);
							i0<=0; i1<=0;  @(posedge clk);	
							i0<=0; i1<=0;  @(posedge clk);
												@(posedge clk);									
							i0<=1; i1<=0;	@(posedge clk);	
			            i0<=1; i1<=0;  @(posedge clk);	
							i0<=1; i1<=0;  @(posedge clk);	
												@(posedge clk);
			$stop; //end simulation							
							
		end //initial
		
endmodule		