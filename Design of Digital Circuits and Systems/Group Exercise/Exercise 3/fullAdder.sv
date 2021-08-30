//Khoa Tran
//07/03/2020
//Lab 1
//This module implements a fullAdder that execute two different one-bit number addition
//that has variable A, B, and cin as inputs, with sum and cout as outputs representing the sum of the addition.

//Implementing the fullAdder with 2 different one-bit binary number and a one-bit value called "cin" as inputs. 
//The outputs are sum and cout that are one-bit outputs that combines to represent the sum of the three inputs. 
//The equation of sum is A XOR B XOR cin. The equation for cout is A and B or cin and (A XOR B). 
module fullAdder (A,B, cin, sum, cout);
	input logic A,B,cin;
	output logic sum,cout;
	
	assign sum = A ^ B ^ cin;
	assign cout = A&B | cin & (A^B);
	
endmodule

//Test the fullAdder by implementing a truth table that consist of a total
//of eight combinations as a binary count from 0 to 7 represented by 
//A, B, and cin
module fullAdder_testbench();
	logic A, B, cin, sum, cout;
	fullAdder dut (A, B, cin, sum, cout);
	
	integer i;
	initial begin
		for (i=0; i<2**3;i++) begin
		 {A, B, cin} = i; #10;
		end //for loop
	
	end //initial
endmodule
