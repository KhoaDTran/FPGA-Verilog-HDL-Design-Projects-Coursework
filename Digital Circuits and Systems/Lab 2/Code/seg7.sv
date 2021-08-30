//Khoa Tran
//07/10/2020
//Lab 2
//This module takes in a 4-bit binary number, and outputs the number 
//associated with the item through leds1, leds2, leds3, leds4, and leds5.
//Any bcd code that isn't associated with an item is ignored and set to be don't care.

//Implementing nseg7 by in 4-bit number input that is connected to the UPC item number
//and outputs the associated the number through the variable leds. Any default input
//that isn't associated with an item is don't cared. 
module seg7 (bcd, leds); 
	input logic [3:0] bcd;
	output logic [6:0] leds;
	always_comb begin 
		case (bcd)	// Light: 6543210
		4'b0000: leds = 7'b1000000; // 0
		4'b0001: leds = 7'b1111001; // 1
		4'b0010: leds = 7'b0100100; // 2
		4'b0011: leds = 7'b0110000; // 3
		4'b0100: leds = 7'b0011001; // 4
		4'b0101: leds = 7'b0010010; // 5
		4'b0110: leds = 7'b0000010; // 6
		4'b0111: leds = 7'b1111000; // 7
		4'b1000: leds = 7'b0000000; // 8
		4'b1001: leds = 7'b1101111; // 9
		default: leds = 7'bX; endcase
	end
endmodule


//Test the seg7 outputs by implementing a truth table
//that test all the possible combinations with bcd[3:0] as the inputs 
module seg7_testbench();
	logic [3:0] bcd;
	logic [6:0] leds;
	
	seg7 dut (.bcd, .leds);
	
	integer i;
	initial begin
		for (i = 0; i< 2**4;i++) begin
			{bcd[0], bcd[1], bcd[2], bcd[3]} = i; #10;
		end //for loop
	
	end //initial
endmodule