//Khoa Tran and Ravi Sangani
//05/14/2020
//Lab 4, Task 2
//Module datapath controls the output of the mid address based on lower and upper bounds
//and otherReset based on the condition if lower is greater than upper indicating the program
//is done searching. This module takes the input of Lfirst, Elower, Eupper in order to
//know when and what to update lower and upper bounds to. Lower and upper changes on the posedge clk,
//based on input conditions, and output mid as the middle value of lower and upper.
module datapath(clk, Lfirst, Elower, Eupper, mid, otherReset);
	input logic clk;
	input logic Lfirst, Elower, Eupper;
	output logic [4:0] mid;
	output logic otherReset;
	logic [4:0] midTemp;
	logic [4:0] lower;
	logic [4:0] upper;
	
	//logic storing mid value
	assign midTemp = (lower + upper)/2;
	
	//sequential logic of lower and upper based on input conditions
	always_ff @(posedge clk)
		begin
			if (Lfirst) begin
				lower <= 5'd0;
				upper <= 5'd31;
			end
			if (Elower) lower <= midTemp + 1;
			if (Eupper) upper <= midTemp - 1;
		end
	
	//output mid
	assign mid = midTemp;
	//output otherRest based on lower > upper
	assign otherReset = (lower > upper);
	
endmodule

//module datapath_testbench is a testbench for datapath
//setting a series of inputs on Lfirst, Elower, and Eupper, in order
//to test the output of mid and otherReset on the posedge clk
module datapath_testbench();
	logic clk, Lfirst, Elower, Eupper;
	
	logic [4:0] mid;
	logic otherReset;

	
	//device under test
	datapath path(.clk, .Lfirst, .Elower, .Eupper, .mid, .otherReset);
	
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	
	//initial simulation
	initial begin
		Lfirst<=1; Elower<=0; Eupper<= 0; @(posedge clk);
		Lfirst<=0; Elower<=1; Eupper<= 0; @(posedge clk);
		Lfirst<=0; Elower<=1; Eupper<= 0; @(posedge clk);
		Lfirst<=0; Elower<=0; Eupper<= 1; @(posedge clk);
		Lfirst<=0; Elower<=0; Eupper<= 1; @(posedge clk);
		Lfirst<=0; Elower<=0; Eupper<= 1; @(posedge clk);
		Lfirst<=1; Elower<=0; Eupper<= 0; @(posedge clk);
		Lfirst<=0; Elower<=0; Eupper<= 1; @(posedge clk);
		Lfirst<=0; Elower<=1; Eupper<= 0; @(posedge clk);
		Lfirst<=0; Elower<=0; Eupper<= 1; @(posedge clk);
		Lfirst<=0; Elower<=1; Eupper<= 0; @(posedge clk);
		Lfirst<=1; Elower<=0; Eupper<= 0; @(posedge clk);
		Lfirst<=0; Elower<=0; Eupper<= 1; @(posedge clk);
		Lfirst<=0; Elower<=0; Eupper<= 1; @(posedge clk);
		Lfirst<=0; Elower<=0; Eupper<= 1; @(posedge clk);
		$stop;
		
	end
endmodule
