//Khoa Tran
//07/29/2020
//Lab 4
//This module implements an FSM that controls the lights outside of the center
//light in the game tug of war. In this FSM, the inputs are L, R, NL, and NR 
//as they are user inputs and checkers for if the lights on the left and right
//of the controlled light is on. This allows for the control of the lightOn
//output as when the game starts and when reset is called to being off. When
//the user input calls the light to be on and when the light next to it is on, 
//the light turns on. The light turns off when a user input turns the light 
//away from the specific light. Inputs and outputs progress on
//positive clock edge.

//Implements normalLight module with input clk, reset, temp, L, R, NL, and NR.
//Outputs lightOn, which acts as the normal light for the tug of war.
//In case of reset or temp, the output of lightOn goes to 0 and follows a state logic to
//output on and off according to the state conditions. 
module normalLight (clk, reset, temp, L, R, NL, NR, lightOn);
	input logic clk, reset, temp;
	// L is true when left key is pressed, R is true when the right key
	//is pressed, NL is true when the light on the left is on, and NR
	//is true when the light on the right is on.
	input logic L, R, NL, NR;
	// when lightOn is true, the normal light should be on.
	output logic lightOn;
	
	logic ns; //next state logic

	//Following block follows state logic with
	//output lightOn depending on L and R inputs
	//but as well as NR and NL when the light is off
	always_comb begin
		case (lightOn)
			0: if ((NL & R & ~L) | (NR & L & ~R)) ns = 1;
						else ns = 0;
			1: if (R ^ L) ns = 0;
						else ns = 1;
		endcase
	end
	
	//sequential logic (DFFs)
		always_ff @(posedge clk) begin
			if (reset || temp)
				lightOn<=0;
			else
				lightOn<=ns;
		end
				
	
endmodule

//Module test the output of the normalLight module by running a sequence of inputs
//on reset, temp, L, R, NL, and NR and testing if the output, lightOn, is correct along
//the positive edges.
module normalLight_testbench();

		logic clk, reset, temp, L, R, NL, NR, lightOn;
		
		normalLight dut (.clk, .reset, .temp, .L, .R, .NL, .NR, .lightOn);
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end //initial
		
		initial begin
		
			reset <= 1;         							@(posedge clk);
			reset <= 0; L<=0; R<=0; 					@(posedge clk);
							L<=1;							  	@(posedge clk);
																@(posedge clk);	
			reset <= 1;                 			   @(posedge clk);	
			reset <= 0;            			 			@(posedge clk);	
							L<=0; R<=1; NL<=1; NR<=0; 	@(posedge clk);
							L<=0; R<=0;						@(posedge clk);
							L<=0; R<=1;						@(posedge clk);
			reset <= 1;                 			   @(posedge clk);	
			reset <= 0;            			 			@(posedge clk);					
							L<=1; R<=1; NL<=0; NR<=0; 	@(posedge clk);	
							L<=1; R<=0; NL<=0; NR<=1; 	@(posedge clk);	
							L<=1; R<=0;						@(posedge clk);	
																@(posedge clk);	
																@(posedge clk);	
																@(posedge clk);
			$stop; //end simulation							
							
		end //initial
		
endmodule		