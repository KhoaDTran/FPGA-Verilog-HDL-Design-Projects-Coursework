//Khoa Tran and Ravi Sangani
//05/14/2020
//Lab 4, Task 2

//Module DE1_SoC implements a binary search algorithm on hardware using a 32x8 ram
//that has a sorted set of values incrementing with incrementing addresses. The binary search algorithm
//uses a controller to output conditions and states for the datapath to manipulate lower and upper 
//bound values to output a mid address to the ram to output the value at the mid address. This
//gets compared with the target data from SW7-0 and continues searching if they don't match. Outputs
//found on LEDR9 and not found on LEDR8, and the mid address on HEX1 and HEX0 if the data is found on the
//ram. Also has input of start to indicate when to start the algorithm. Using CLOCK_50, states and conditions
//progress in order to implement binary search on hardware.
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	input logic CLOCK_50;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	logic [7:0] dataTemp;
	logic [7:0] valueTemp;
	logic [4:0] readAddr;
	logic Lfirst, Elower, Eupper;
	logic foundTemp;
	
	logic [31:0] div_clk;
	parameter whichClock = 12; 
	//instantiation of clock_divider
	clock_divider cdiv (.clock(CLOCK_50), .divided_clocks(div_clk));
	logic clkSelect;
	assign clkSelect = CLOCK_50; // for simulation
	
	//assign clkSelect = div_clk[whichClock]; // for board
	assign LEDR[0] = clkSelect;
	logic otherTemp;
	
	//instantiation of controller module with data input and ram mid value input as well as SW[9] for start, outputing Lfirst, Elower, Eupper for datapath, and found for LEDR
	controller control(.clk(clkSelect), .reset(~KEY[0]), .data(SW[7:0]), .value(valueTemp), .start(SW[9]), .Lfirst, .Found(foundTemp), .Elower, .Eupper, .other(otherTemp));
	//instantiation of ram module, getting value at mid address from datapath
	ram32x8 ram(.address(readAddr),	.clock(CLOCK_50), .data(8'd0),	.wren(1'b0), .q(valueTemp));
	//instantiation of datapath using inputs from controller to output mid value to ram and otherReset
	datapath data(.clk(clkSelect), .Lfirst, .Elower, .Eupper, .mid(readAddr), .otherReset(otherTemp));
	//instantiation of seg7, displaying mid address value based on if found condition is true
	seg7 display(.addr(readAddr), .found(foundTemp), .hex5(HEX1), .hex4(HEX0));
	
	//found and not found LEDR outputs
	assign LEDR[9] = foundTemp;
	assign LEDR[8] = ~LEDR[9];
	
	//turn of other hex
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
endmodule

//Module testbench for DE1_SoC, testing for outputs of HEX1, HEX0, LEDR9, LEDR8
//is correct along the posedge CLOCK_50 with a series of inputs on
//KEY[0] as reset, SW[9] as start, and SW7-0 as the target data to search
`timescale 1 ps / 1 ps
module DE1_SoC_testbench();
	logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;

	DE1_SoC dut (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	parameter clock_period = 100;
		
		initial begin
			CLOCK_50 <= 0;
			forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
					
		end //initial
	
	initial begin
		KEY[0] <= 1'b0; SW[9] <= 1'b0; SW[7:0] <= 4'b0001;  @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[7:0] <= 4'b0001;  @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[7:0] <= 4'd3;  @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[7:0] <= 4'd3;  @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[7:0] <= 4'd3;  @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[7:0] <= 4'd3;  @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[7:0] <= 4'd3;  @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[7:0] <= 4'd20;  @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[7:0] <= 4'd20;  @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[7:0] <= 4'd20;  @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[7:0] <= 4'd20;  @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[7:0] <= 4'd20;  @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[7:0] <= 4'd24;  @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[7:0] <= 4'd24;  @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[7:0] <= 4'd24;  @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[7:0] <= 4'd24;  @(posedge CLOCK_50);
		
		$stop;
	end

endmodule

//clock_divider module has inputs of the clock, reset, and the
//32 bit divided_clock which allows to sequence through and
//output whenever the postive edge has been reached on the clock 
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
	input logic clock;
	output logic [31:0] divided_clocks = 0;

	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end

endmodule
