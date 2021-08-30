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
	
	logic a[3:0];
	logic b[3:0];
	logic sum[3:0];
	
	assign a[3] = SW[4];
	assign a[2] = SW[3];
	assign a[1] = SW[2];
	assign a[0] = SW[1];
	assign b[3] = SW[8];
	assign b[2] = SW[7];
	assign b[1] = SW[6];
	assign b[0] = SW[5];
		
	assign LEDR[3] = sum[3];
	assign LEDR[2] = sum[2];
	assign LEDR[1] = sum[1];
	assign LEDR[0] = sum[0];
	
	fullAdder4 FA (.A(a), .B(b), .cin(SW[0]), .sum(sum), .cout(LEDR[4]));
	
	assign HEX0 = 7'b1000010;
	assign HEX1 = 7'b0101011;
	assign HEX2 = 7'b1001111;
	assign HEX3 = 7'b0100001;
	assign HEX4 = 7'b0100001;
	assign HEX5 = 7'b0001000;
	
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
	for (i=0; i<2**9; i++) begin
		SW[8:0] = i; #10;
	end
end

endmodule
