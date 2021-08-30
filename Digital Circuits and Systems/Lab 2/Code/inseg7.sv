//Khoa Tran
//07/10/2020
//Lab 2
//This module instantiates the seg7 module by associated the HEX0 output with the
//leds and the SW[9:6] with the bcd 4-bit binary number. 

//Implements inseg7 by instanitiating seg7 and associating the switches and Hex0
//to the appropriate variable in the seg7 module
module inseg7 (SW, HEX0);
	output logic HEX0;
	input logic [9:6] SW;
	
	seg7 inst_1(.bcd(SW), .leds(HEX0));
	
endmodule

//Test the inseg7 by taking the SW and HEX0 under test
//and a truth table that has all the possible combinations for
//a 4-bit binary number
module inseg7_testbench();
	logic HEX0;
	logic [9:6] SW;
	
	inseg7 dut(.SW, .HEX0);
	integer i;
	initial begin;
	for (i=0; i<2**4; i++) begin
		SW[9:6] = i; #10;
	end
end

endmodule