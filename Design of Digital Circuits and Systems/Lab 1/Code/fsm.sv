//Khoa Tran
//04/12/2021
//CSE 371
//Lab 1, Task 1
//This module represents the finite state machine for the parking lot as it represents
//the input of sensor a and b. As a and b are one-bit inputs, the module goes through
//the order of progression of the two inputs in order to determine either an enter or
//an exit output value.

//Implementing the fsm module with the inputs clk, reset, a, and b. The enter and 
//exit variable outputs are a one-bit value indicating either the parking lot got one
//more or less car. This fsm module allows for reset to start the input sequence and 
//current state over again. Lastly, the module progress to the next input value when clk is a positive edge.
module fsm (clk, reset, a, b, enter, exit);
	input logic clk, reset; //input for clk, reset
	input logic a, b; //input for sensor a and b
	output logic exit; //output for exit
	output logic enter; //output for enter
	
	enum {S0, S1, S2, S3} ps, ns; //all five states, present state, next state
	
	always_comb begin //comb next state logic
		case (ps)
			S0: if (a & ~b) ns = S1; //initial state, both sensor is unblocked
					 else if (~a & b) ns = S3;
					 else ns = S0;
			S1: if (a & b) ns = S2; //state of sensor a blocked, and b unblocked
					 else if (~a & ~b) ns = S0;
					 else ns = S1;
			S2: if (a & ~b) ns = S1; //state of both sensors blocked
					 else if (~a & b) ns = S3;
					 else ns = S2;
			S3: if (a & b) ns = S2; //state of sensor b blocked, and a unblocked
					 else if (~a & ~b) ns = S0;
					 else ns = S3;
		endcase
	end
	
	// equation for output of enter and exit as it depends on present state and input, a and b.
	assign enter = ((ps == S3) & ~a & ~b);
	assign exit = ((ps == S1) & ~a & ~b);
		
		//sequential logic (DFFS)
		always_ff @(posedge clk) begin
			if (reset)
				ps <= S0;
			else
				ps <= ns;
		end
endmodule

//Module test the output of the fsm module by running a sequence of inputs
//on a and b and testing if the output, enter and exit, is correct.
module fsm_testbench();

	logic clk, reset, a, b, enter, exit;
	
	//devices under test
	fsm dut (.clk, .reset, .a, .b, .enter, .exit);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	//initial simulation
	initial begin
		reset <= 1;							@(posedge clk);
		reset <= 0; a<=0; b<=0;			@(posedge clk);
		reset <= 0; a<=1; b<=0;			@(posedge clk);
		reset <= 0; a<=1; b<=1;			@(posedge clk);
		reset <= 0; a<=0; b<=1;			@(posedge clk);
		reset <= 0; a<=0; b<=0;			@(posedge clk);
		reset <= 0; a<=1; b<=0;			@(posedge clk);
		reset <= 0; a<=1; b<=1;			@(posedge clk);
		reset <= 0; a<=0; b<=1;			@(posedge clk);
		reset <= 0; a<=0; b<=0;			@(posedge clk);
		reset <= 0; a<=0; b<=1;			@(posedge clk);
		reset <= 0; a<=1; b<=1;			@(posedge clk);
		reset <= 0; a<=1; b<=0;			@(posedge clk);
		reset <= 0; a<=0; b<=0;			@(posedge clk);
		reset <= 0; a<=0; b<=0;			@(posedge clk);
		
		$stop; //end simulation
	end
endmodule
		