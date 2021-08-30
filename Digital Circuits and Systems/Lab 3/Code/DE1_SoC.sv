//Khoa Tran
//07/20/2020
//Lab 3
//This module uses the wind module in order to execute a 2-bit number input that determines
//the wind conditions. If the input is calm, the LEDR2-0 will alternate between 101 and 010.
//If the wind conditions are right to left, the LEDR2-0 will alternate between 001, 010, and 100,
//going from right to left. If the inpuit is left to right, the LEDR2-0 will alternate between 100, 010, and 001,
//going from left to right. Additionally, implements a clock that is connected to LEDR[5] and will
//express the input whenever the clock, and led is on with the positve edge

//Implementing the wind module with two different 1-bit binary number input,
//which is connected to SW[1] and SW[0] in order to indicate the wind conditions. 
//The outputs from the wind module is connected to the LEDR[2:0]. The LEDR5 is connected to the clock
//in order to indicate when the positve edge is reached to progress the inputs and outputs. 
//This is done by instanitating the wind module in to the correct switches and leds on the board.
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	input logic CLOCK_50; // 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // Active low property
	input logic [9:0] SW;

	// Generate clk off of CLOCK_50, whichClock picks rate.

	logic [31:0] clk;

	parameter whichClock = 25;

	clock_divider cdiv (CLOCK_50, clk);

	logic reset;  // configure reset

	assign reset = ~KEY[0]; // Reset when KEY[0] is pressed
	
	assign LEDR[5] = clk[whichClock];
	
	// instantiates Hazard light and assigned corresponding ports
	wind wind1 (.clk(clk[whichClock]), .reset(reset), .i0(SW[1]), .i1(SW[0]), .out1(LEDR[2]), .out2(LEDR[1]), .out3(LEDR[0]));

endmodule

	// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...

//clock_divider module has inputs of the clock and the
//32 bit divided_clock which allows to sequence through and
//output whenever the postive edge has been reached on the clock 
module clock_divider (clock, divided_clocks);
	input logic clock;
	output logic [31:0] divided_clocks;

	initial begin
		divided_clocks <= 0;
	end

	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
   end

endmodule