//Khoa Tran
//07/03/2020
//Lab 1
//This module implements a fullAdder with 4 bits numbers that execute two different 4-bit number addition
//that has variable A[3-0], B[3-0], and cin, a 1-bit number, as inputs, with sum[3-0] being a 4-bit output
//and cout as a one-bit output representing the sum of the addition.

//Implementing the fullAdder4 with 2 different 4-bit binary number and a one-bit value called "cin" as inputs. 
//The outputs are sum[3-0] and cout that are a 4-bit and 1-bit outputs
//that combines to represent the sum of the three inputs. The module fullAdder4 calls on the original
//fullAdder in order to use the equations that sum and cout represent. This module calls on the
//fullAdder module four times in order to execute the addition of two 4-bit number.
module fullAdder4 (A, B, cin, sum, cout);
	input logic A[3:0];
	input logic B[3:0];
	input logic cin;
	
	output logic sum[3:0];
	output logic cout;
	
	logic c0;
	logic c1;
	logic c2;
	
	fullAdder FA0(.A(A[0]), .B(B[0]), .cin(cin), .sum(sum[0]), .cout(c0));
	fullAdder FA1(.A(A[1]), .B(B[1]), .cin(c0), .sum(sum[1]), .cout(c1));
	fullAdder FA2(.A(A[2]), .B(B[2]), .cin(c1), .sum(sum[2]), .cout(c2));
	fullAdder FA3(.A(A[3]), .B(B[3]), .cin(c2), .sum(sum[3]), .cout(cout));
	
endmodule

//Test the fullAdder4 by implementing a truth table that consist of a total
//of 256 combinations as a binary count from 0 to 255 represented by 
//A, B, and cin
module fullAdder4_testbench();

	logic A[3:0], B[3:0], cin, sum[3:0], cout;
	
	fullAdder4 dut (A, B, cin, sum, cout);
	
	integer i;
	initial begin
		for (i = 0; i< 2**8;i++) begin
			{A[0], A[1], A[2], A[3], B[0], B[1], B[2], B[3], cin} = i; #10;
		end //for loop
	
	end //initial
endmodule
