//Khoa Tran
//07/03/2020
//Lab 1
//This module uses the fullAdder4 module in order to execute a 4-bit number addition
//that has switches as inputs, LEDs as outputs, and also displaying the word "Adding" on the HEX 7 segment display.

//Implementing the fullAdder but with 2 different 4-bit binary number and a one-bit value as inputs. The SW[0]
//represent a one-bit value with the variable "cin". The SW[1-4] represents a 4-bit binary number with the variable a.
//The SW[5-8] represents a second set of 4-bit binary number as the varaible b. The output is the sum of the two different
//4-bit numbers represented by the 4-bit variable sum as LEDR[3-0], and with a one-bit value called "cout" represnted by
//LEDR[4]. Additionally, assigns the individual 7 segment HEX from 5 to 0, in order to display the word "Adding"
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	
	fullAdder FA (.A(SW[2]), .B(SW[1]), .cin(SW[0]), .sum(LEDR[0]), .cout(LEDR[1]));
	
	assign HEX0 = 7'b1111111;
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
endmodule

//Testing the DE1_SoC module by implementing a for loop that ignores SW[9]
//and a truth table that counts up the binary numbers for switches 0 to 8
module DE1_SoC_testbench();

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);

	integer i;
	initial begin
	SW[9] = 1'b0;
	SW[8] = 1'b0;
	for (i=0; i<2**8; i++) begin
		SW[7:0] = i; #10;
	end
end

endmodule
