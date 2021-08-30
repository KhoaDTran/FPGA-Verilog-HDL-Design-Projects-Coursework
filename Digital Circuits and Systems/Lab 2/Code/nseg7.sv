//Khoa Tran
//07/10/2020
//Lab 2
//This module takes in a 3-bit binary number, and outputs the number and
//word associated with the item through leds1, leds2, leds3, leds4, and leds5.
//Any bcd code that isn't associated with an item is ignored and set to not display anything.

//Implementing nseg7 by in 3-bit number input that is connected to the UPC item number
//and outputs the associated name of the item along with the number through the variables
//leds1-5. 
module nseg7 (bcd, leds1, leds2, leds3, leds4, leds5); 
	input logic [2:0] bcd;
	output logic [6:0] leds1;
	output logic [6:0] leds2;
	output logic [6:0] leds3;
	output logic [6:0] leds4;
	output logic [6:0] leds5;
	always_comb begin 
		case (bcd)	// Light: 6543210
		3'b000: begin
					leds1 = 7'b1000000; // 0
					leds2 = 7'b0010010;
					leds3 = 7'b0001001;
					leds4 = 7'b1000000;
					leds5 = 7'b0000110;
					end
		3'b001: begin
					leds1 = 7'b1111001; // 1
					leds2 = 7'b1100001;
					leds3 = 7'b0000110;
					leds4 = 7'b0010101;
					leds5 = 7'b1000111;
					end
		3'b010: begin
					leds1 = 7'b0100100; // 2
					leds2 = 7'b1111111;
					leds3 = 7'b1111111;
					leds4 = 7'b1111111;
					leds5 = 7'b1111111;
					end
		3'b011: begin
					leds1 = 7'b0110000; // 3
					leds2 = 7'b0000011;
					leds3 = 7'b1111001;
					leds4 = 7'b0001010;
					leds5 = 7'b0000110;
					end
		3'b100: begin
					leds1 = 7'b0011001; // 4
					leds2 = 7'b0010010;
					leds3 = 7'b1000001;
					leds4 = 7'b1111001;
					leds5 = 7'b0000111;
					end
		3'b101: begin
					leds1 = 7'b0010010; // 5
					leds2 = 7'b1000110;
					leds3 = 7'b1000000;
					leds4 = 7'b0001000;
					leds5 = 7'b0000111;
					end
		3'b110: begin
					leds1 = 7'b0000010; // 6
					leds2 = 7'b0010010;
					leds3 = 7'b1000000;
					leds4 = 7'b1000110;
					leds5 = 7'b0001010;
					end	
		3'b111: begin
					leds1 = 7'b1111000; // 7
					leds2 = 7'b1111111;
					leds3 = 7'b1111111;
					leds4 = 7'b1111111;
					leds5 = 7'b1111111;
					end
		default: begin
					leds1 = 7'b1111111;
					leds2 = 7'b1111111;
					leds3 = 7'b1111111;
					leds4 = 7'b1111111;
					leds5 = 7'b1111111;
					end	
		endcase
	end
endmodule

//Test the nseg7 outputs by implementing a truth table
//that test all the possible combinations with bcd as the inputs 
module nseg7_testbench();
	logic [3:0] bcd;
	logic [6:0] leds1;
	logic [6:0] leds2;
	logic [6:0] leds3;
	logic [6:0] leds4;
	logic [6:0] leds5;
	
	nseg7 dut (.bcd, .leds1, .leds2, .leds3, .leds4, .leds5);
	
	integer i;
	initial begin
		for (i = 0; i< 2**3;i++) begin
			{bcd[0], bcd[1], bcd[2]} = i; #10;
		end //for loop
	
	end
	//initial
endmodule