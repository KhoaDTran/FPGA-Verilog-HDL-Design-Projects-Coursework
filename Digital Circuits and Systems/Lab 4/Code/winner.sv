//Khoa Tran
//07/29/2020
//Lab 4
//This module implements an FSM that controls the winner between two users
//in the game tug of war. In this FSM, the inputs are L, R, loc1, and loc2
//as they are user inputs and checkers for the location of the current
//lightOn output. This allows for the control of the winning state as it allows
//for following state logic and the conditions in order to progress into a state
//where either the left user is the winner or the right user is the winner. 
//When reset is called, there's no winner and inputs and outputs progress on
//positive clock edge.

//Implements winner module with input clk, reset, L, R, loc1, and loc2.
//Outputs out, which acts as the 7-bit binary output for the HEX board
//display for the game, tug of war. In reset, the output of out goes to 0 
//and follows a state logic to output the winner according to the state conditions. 
module winner (clk, reset, L, R, loc1, loc2, out);
	input logic clk, reset;
	// L is true when left key is pressed, R is true when the right key
	//is pressed, loc1 is true when the light on LEDR[9], and loc2
	//is true when the light on LEDR[1].
	input logic L, R, loc1, loc2;
	
	output logic [6:0] out;
	
	enum {S0, S1, S2} ps, ns; // Present state, next state

	//Following block follows state logic with
	//controlling the state at the start and
	//which state it enters through the location of the light
	//with loc1 and loc2 and the inputs of L and R. Outputs
	//7-bit as a 7-segment output for HEX display.
	always_comb begin
		case (ps)
			S0: if (loc2 & R & (~L)) begin
						ns = S1; //right winner
						out = 7'b1111001; //display of 1
						end
					else if (loc1 & L & (~R)) begin
						ns = S2; //left winner
						out = 7'b0100100; //display of 2
						end
					else begin 
						ns = S0;
						out = 7'b1111111;
						end
			S1: begin //right winner
					ns = S1;
					out = 7'b1111001; //display of 1
					end
			S2: begin
					ns = S2; //left winner
					out = 7'b0100100; //display of 2
					end
			default: out = 7'b1111111;
		endcase
	end

	
	//sequential logic (DFFs)
		always_ff @(posedge clk) begin
			if (reset)
				ps <= S0;
			else
				ps <= ns;
		end
				
	
endmodule

//Module test the output of the winner module by running a sequence of inputs
//on reset, L, R, loc1, and loc2 and testing if the output, out, is correct along
//the positive edges.
module winner_testbench();

		logic clk, reset, L, R, loc1, loc2;
		logic [6:0] out;
		
		winner dut (.clk, .reset, .L, .R, .loc1, .loc2, .out);
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end //initial
		
		initial begin
		
			reset <= 1;         									@(posedge clk);
			reset <= 0; L<=0; R<=0; 							@(posedge clk);
							L<=1;	R<=0; loc1<=1;	loc2<=0;	  	@(posedge clk);
																		@(posedge clk);	
			reset <= 1;                 			   		@(posedge clk);	
			reset <= 0;            			 					@(posedge clk);	
							L<=0; R<=1; loc1<=0;	loc2<=1;	 	@(posedge clk);
																		@(posedge clk);
																		@(posedge clk);
			reset <= 1;                			   		@(posedge clk);	
			reset <= 0;            			 					@(posedge clk);					
							L<=1; R<=1; loc1<=0; loc2<=1;		@(posedge clk);	
							L<=1; R<=1;	loc1<=1;	loc2<=0;		@(posedge clk);
							L<=1; R<=0;	loc1<=1;	loc2<=0;		@(posedge clk);	
																		@(posedge clk);	
																		@(posedge clk);	
																		@(posedge clk);
			$stop; //end simulation							
							
		end //initial
		
endmodule		