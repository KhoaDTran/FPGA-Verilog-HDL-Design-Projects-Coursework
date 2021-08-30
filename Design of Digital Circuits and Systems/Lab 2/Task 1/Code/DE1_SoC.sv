//Khoa Tran
//04/22/2021
//Lab 2, Task 1
//This module implements a 32x4 ram that takes in data values and an address
//and displays the data in hexadecimal on hex2 display as well as the address
//in hexadecimal on hex5 and hex4 display. The address is taken from SW8-4, as the
//data is taken from SW3-0. The signal to write to the ram is given from SW9.
//As the clk that is set to KEY[0] goes to posedge, the ram writes the given data
//into the given address. This module continously outputs the current value on
//HEX0 in hexadecimal of the ram at the given address from SW3-0. 
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	logic [3:0] out;
	
	//instantiating addr module passing SW8-4 to address and outputs to HEX5 and HEX4
	addr display_addr(.addr(SW[8:4]), .hex5(HEX5), .hex4(HEX4));
	//instantiating display_data module passing SW3-0 to data and outputs to HEX2
	display_data data1(.data(SW[3:0]), .hex(HEX2));
	//instantiating ram_file module passing SW9 as wr_sig, KEY[0] as clk, in data as SW3-0 and
	//SW8-4 as address, and output the data to logic out
	ram_file ram(.clk(~KEY[0]), .wr_sig(SW[9]), .in_data(SW[3:0]), .addr(SW[8:4]), .out_data(out));
	//instantiating display_data to output to HEX0 the out from ram_file
	display_data data2(.data(out), .hex(HEX0));
	
	assign HEX1 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	
endmodule

//Testing the DE1_SoC module by going through a series of inputs on KEY[0] as the 
//clk and SW[9] as the wr_sig, and SW[8:0] representing the address and the data
//seeing if HEX5, HEX4, HEx2, and HEX0 is correct.
module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut(.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);

	integer i;
	initial begin
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8:4] <= 5'b00001; SW[3:0] <= 4'b0001; #10;
		KEY[0] <= 1'b0; SW[9] <= 1'b1; SW[8:4] <= 5'b00001; SW[3:0] <= 4'b0001; #10;
		KEY[0] <= 1'b1; SW[9] <= 1'b0; SW[8:4] <= 5'b00010; SW[3:0] <= 4'b0010; #10;
		KEY[0] <= 1'b0; SW[9] <= 1'b0; SW[8:4] <= 5'b00010; SW[3:0] <= 4'b0010; #10;
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[8:4] <= 5'b00100; SW[3:0] <= 4'b0100; #10;
		KEY[0] <= 1'b0; SW[9] <= 1'b1; SW[8:4] <= 5'b00100; SW[3:0] <= 4'b0100; #10;
		KEY[0] <= 1'b1; SW[9] <= 1'b1; SW[8:4] <= 5'b01000; SW[3:0] <= 4'b1000; #10;
		KEY[0] <= 1'b0; SW[9] <= 1'b1; SW[8:4] <= 5'b01000; SW[3:0] <= 4'b1000; #10;
		$stop;
	end

endmodule

