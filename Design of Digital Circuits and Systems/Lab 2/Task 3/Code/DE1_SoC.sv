//Khoa Tran
//04/22/2021
//Lab 2, Task 3
//This module implements a FIFO queue for the ram size 16x8, as inputs of 
//SW7-0 provides the data for the ram, SW9 for if the user wants to read, SW8
//for if the user wants to write. The concept is that as the user reads and writes
//data, the FifO_Control will decide which address to read from and write to based
//on the first in first out condition of a queue as it reads the least recent data.
//This module also implements an empty and full on LEDR8 and 9 to indicate if the 
//ram is full or empty, so that the user doesn't read on empty and write on full.
//Using CLOCK_50 to simulate and 0.75hz clock on the board, read data is on HEX1 and
//HEX0 as write data is on HEX5 and 4. Also has ablity to reset the fifo to default conditions.
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic CLOCK_50;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	logic reset;
	logic [31:0] div_clk;

	assign reset = ~KEY[0]; //third switch connected to reset
	parameter whichClock = 25; // 0.75 Hz clock
	
	
	clock_divider cdiv (.clock(CLOCK_50), .divided_clocks(div_clk));

	logic clkSelect;
 
	assign clkSelect = CLOCK_50; // for simulation
	
	//assign clkSelect = div_clk[whichClock]; // for board
	
	//LEDR[0] connected to clk
	assign LEDR[0] = clkSelect;
	
	logic [7:0] out;
	logic wrenable;
	logic emptyout;
	logic fullout;
	logic [3:0] readout;
	logic [3:0] writeout;
	
	//instantiating of data2 twice of each 4 bits of the data from SW7-0, showing on HEX5 and HEX4
	data2 displaydata1(.data(SW[7:4]), .hex(HEX5));
	data2 displaydata2(.data(SW[3:0]), .hex(HEX4));
	
	//instantiating FIFO_Control passing in SW9 for read and SW8 for write, and outputing empty on LEDR8 and full on LEDR9, as well as read and write address for the ram
	FIFO_Control fifo(.clk(clkSelect), .reset(reset), .read(SW[9]), .write(SW[8]), .wr_en(wrenable), .empty(LEDR[8]), .full(LEDR[9]), .readAddr(readout), .writeAddr(writeout));
	//instantiating ram, as data is from the switch and read and write address and wren is from the FIFO_Control, outputing q on out
	ram16x8 mem(.clock(clkSelect), .data(SW[7:0]), .rdaddress(readout), .wraddress(writeout), .wren(wrenable), .q(out));
	
	//instantiating of outControl twice of each 4 bits of the output data from ram, showing on HEX1 and HEX0
	outControl rdata(.data(out[7:4]), .hex(HEX1), .switch(SW[9]));
	outControl r2data(.data(out[3:0]), .hex(HEX0), .switch(SW[9]));
	
	//show nothing on hex3 and 2
	assign HEX3 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	
	
endmodule

//Testing the DE1_SoC module by implementing a series of input values on KEY0, SW9-0 
//in order to test if the output on HEX5, HEX4, HEX1, and HEX0 is correct on posedge
//CLOCK_50
`timescale 1 ps / 1 ps
module DE1_SoC_testbench();
	logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	//device under test
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	parameter clock_period = 100;
		
		initial begin
			CLOCK_50 <= 0;
			forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
					
		end //initial
	
	//initial simulation
	initial begin
		KEY[0] <= 1'b0; SW[9] <= 1'b0; SW[8] <= 1'b0; SW[7:0] <= 8'b00000000; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000010; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000011; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[8] <= 1'b0; SW[7:0] <= 8'b00000000; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[8] <= 1'b0; SW[7:0] <= 8'b00000000; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[8] <= 1'b1; SW[7:0] <= 8'b00000111; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[8] <= 1'b0; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8] <= 1'b1; SW[7:0] <= 8'b00000001; @(posedge CLOCK_50);
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
