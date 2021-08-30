//Khoa Tran
//04/22/2021
//Lab 2, Task 2
//This module implements a 32x4 ram that takes in data values and an address
//and displays the data in hexadecimal on hex1 display as well as the address
//in hexadecimal on hex5 and hex4 display. The address is taken from SW8-4, as the
//data is taken from SW3-0. The signal to write to the ram is given from KEY3.
//As the clk goes to posedge, the ram writes the given data
//into the given address if the wren is true. The output of the ram is the data
//at the address given from the counter. As each posedge clk, the counter increments
//by 1, so the output on the hex0 display goes through the data on the 32x4 ram 
//built in the IP Catalog Library with the associated ram32x4.mif file for initial
//memory data values for each address.
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
	
	//assign clkSelect = div_clk[whichClock]; // for board
	assign clkSelect = CLOCK_50; //for simulation
	
	assign LEDR[0] = clkSelect;
	assign LEDR[3] = CLOCK_50;
	
	logic [3:0] out;
	logic [4:0] read;
	
	//instantiating display_data2, output hex display value of the given data from SW3-0 on HEX1
	display_data2 wdata(.data(SW[3:0]), .hex(HEX1));
	
	//instantiating addr2, output hex display value on HEX5 and HEX4, from given address from SW8-4
	addr2 wradd(.addr(SW[8:4]), .hex5(HEX5), .hex4(HEX4));
	
	//instantiating counter, outputing count to logic read for read address
	counter raddr(.reset(reset), .clk(clkSelect), .rdaddress(read), .hex5(HEX3), .hex4(HEX2));
	
	//instantiating addr2, output read address on HEX3 and HEX2
	//addr2 readdr(.addr(read), .hex5(HEX3), .hex4(HEX2));
	
	//instantiating ram32x4, to write data and output data from given address from the counter output
	ram32x4 mem(.clock(CLOCK_50), .data(SW[3:0]), .rdaddress(read), .wraddress(SW[8:4]), .wren(~KEY[3]), .q(out));
	
	//instantiating display_data2, to display on HEX0 the output data from given ram32x4
	display_data2 rdata(.data(out), .hex(HEX0));
	
	
endmodule

//Testing the DE1_SoC module by going through a series of inputs on KEY[0] as the 
//reset and KEY[3] as the wren, and SW[8:0] representing the address and the data
//seeing if HEX5, HEX4, HEX2, HEX1, and HEX0 is correct.
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
		KEY[0] <= 1'b0; KEY[3] <= 1'b0; SW[3:0] <= 4'b0001; SW[8:4] <= 5'b00001; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; KEY[3] <= 1'b0; SW[3:0] <= 4'b0001; SW[8:4] <= 5'b00010; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; KEY[3] <= 1'b0; SW[3:0] <= 4'b0010; SW[8:4] <= 5'b00011; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; KEY[3] <= 1'b0; SW[3:0] <= 4'b0010; SW[8:4] <= 5'b00100; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; KEY[3] <= 1'b0; SW[3:0] <= 4'b0100; SW[8:4] <= 5'b00101; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; KEY[3] <= 1'b0; SW[3:0] <= 4'b0100; SW[8:4] <= 5'b00110; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; KEY[3] <= 1'b0; SW[3:0] <= 4'b1000; SW[8:4] <= 5'b00111; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; KEY[3] <= 1'b0; SW[3:0] <= 4'b1000; SW[8:4] <= 5'b01000; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; @(posedge CLOCK_50);
		KEY[0] <= 1'b1; @(posedge CLOCK_50);
		
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
