//Khoa Tran
//07/10/2020
//Lab 2
//This module implements a electronic detector device where the variables U, P, and C are
//1-bit number that combines to represent an item from a store. These items also have an
//input M, which is a marker to determine if an expensive product was sold. Lastly, the
//outputs are Discounted and Stolen, which are both 1-bit number that represents if an 
//item is discounted and stolen or not, based on the mark and if the product was expensive.

//Implementing the UPC with 4 different 1-bit binary number as inputs and two 1-bit outputs
//called Discounted and Stolen. Depending on the U,P,C code, the item could be discounted
//or not. The equation for Discounted takes in all the items that are suppose to be discounted.
//The stolen will output 1 if the item is expensive and M is 0. The expensive equation only takes
//expensive items that are associated with a specific UPC code. 
module UPC (U,P, C, M, Discounted, Stolen);
	input logic U,P,C,M;
	output logic Discounted,Stolen;
	logic Expensive;
	
	assign Discounted = P | (U & C);
	assign Expensive = ((~P) & U) | (~(P|C));
	assign Stolen = (~M) & Expensive;
	
endmodule

//Test the UPC by a truth table that consist of a total
//of 16 combinations as a binary count from 0 to 15 represented by 
//U, P, C, and M
module UPC_testbench();
	logic U, P, C, M, Discounted, Stolen;
	UPC dut (U, P, C, M, Discounted, Stolen);
	
	integer i;
	initial begin
		for (i=0; i<2**4;i++) begin
		 {U, P, C, M} = i; #10;
		end //for loop
	
	end //initial
endmodule
