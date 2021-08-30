//Khoa Tran
//08/05/2020
//Lab 5
//This module implements a combinational logic that is a comparator
//between two 10-bit inputs. When input1, In1, is greater than
//input2, In2, then the output, Gt would be true. Otherwise, the output
//is false. When reset is called, Gt goes to false. 

//Implements comparator that takes in reset, In1, In2, and outputs
//Gt as true when In1 is greater than In2. Otherwise or in case of reset,
//the output to Gt is false.
module compare (reset, In1, In2, Gt); 
	input logic [9:0] In1, In2; //The two 10-bit Inputs In1 and In2 
	output logic Gt;
	input logic reset;

	always_comb
	begin
		if (In1 > In2)
			Gt = 1;
		else if (reset)
			Gt = 0;
		else
			Gt = 0;
	end

endmodule

//Module test the output of the compare module by running a sequence of inputs
//on reset, In1, and In2 to test if the Gt is correct.
module compare_testbench();

		logic reset, Gt;
		logic [9:0] In1, In2;
		
		compare dut (.reset, .In1, .In2, .Gt);
		
		integer i;
		initial begin
			for (i = 0; i< 2**20;i++) begin
				{In1[0], In1[1], In1[2], In1[3], In1[4], In1[5], In1[6], In1[7], In1[8], In1[9], In2[0], In2[1], In2[2], In2[3], In2[4], In2[5], In2[6], In2[7], In2[8], In2[9]} = i; #10;
			end //for loop
	
		end //initial
endmodule
