//Khoa Tran
//04/22/2021
//Lab 2, Task 2
//This module controls the logic case for displaying the hex value of the address
//on the hex 7-seg display board. With inputs of address as 5 bits, combinational
//logic through the cases to have the hex output that matches the input data value
module addr2#(parameter addr_width = 5) (addr, hex5, hex4);
	input logic [addr_width - 1:0] addr;
	output logic [6:0] hex5, hex4;
	
	//logic for 7-seg display for hex values 1-15
	logic [6:0] zero, one, two, three, four, five, six, seven, eight, nine, A, B, C, D, E, F;
	assign zero = 7'b1000000;
	assign one = 7'b1111001;
	assign two = 7'b0100100;
	assign three = 7'b0110000;
	assign four = 7'b0011001;
	assign five = 7'b0010010;
	assign six = 7'b0000010;
	assign seven = 7'b1111000;
	assign eight = 7'b0000000;
	assign nine = 7'b0010000;
	assign A = 7'b0001000;
	assign B = 7'b0000011;
	assign C = 7'b1000110;
	assign D = 7'b0100001;
	assign E = 7'b0000110;
	assign F = 7'b0001110;
	
	//combinational for cases of addr values 1-31 to display in hex5-4
	always_comb begin
				case (addr)			
					5'b00000: begin
								hex5 = zero;
								hex4 = zero;
								end
					5'b00001: begin
								hex5 = zero;
								hex4 = one;
								end
					5'b00010: begin
								hex5 = zero;
								hex4 = two;
								end
					5'b00011: begin
								hex5 = zero;
								hex4 = three;
								end
					5'b00100: begin
								hex5 = zero;
								hex4 = four;
								end
					5'b00101: begin
								hex5 = zero;
								hex4 = five;
								end
					5'b00110: begin
								hex5 = zero; 
								hex4 = six;
								end
					5'b00111: begin
								hex5 = zero; 
								hex4 = seven;
								end
					5'b01000: begin
								hex5 = zero; 
								hex4 = eight;
								end
					5'b01001: begin
								hex5 = zero; 
								hex4 = nine;
								end
					5'b01010: begin
								hex5 = zero; 
								hex4 = A;
								end
					5'b01011: begin
								hex5 = zero; 
								hex4 = B;
								end
					5'b01100: begin
								hex5 = zero; 
								hex4 = C;
								end
					5'b01101: begin
								hex5 = zero; 
								hex4 = D;
								end
					5'b01110: begin
								hex5 = zero; 
								hex4 = E;
								end
					5'b01111: begin
								hex5 = zero; 
								hex4 = F;
								end
					5'b10000: begin
								hex5 = one; 
								hex4 = zero;
								end
					5'b10001: begin
								hex5 = one; 
								hex4 = one;
								end
					5'b10010: begin
								hex5 = one; 
								hex4 = two;
								end
					5'b10011: begin
								hex5 = one; 
								hex4 = three;
								end
					5'b10100: begin
								hex5 = one; 
								hex4 = four;
								end
					5'b10101: begin
								hex5 = one; 
								hex4 = five;
								end
					5'b10110: begin
								hex5 = one; 
								hex4 = six;
								end
					5'b10111: begin
								hex5 = one; 
								hex4 = seven;
								end
					5'b11000: begin
								hex5 = one; 
								hex4 = eight;
								end
					5'b11001: begin
								hex5 = one;
								hex4 = nine;
								end
					5'b11010: begin
								hex5 = one; 
								hex4 = A;
								end
					5'b11011: begin
								hex5 = one; 
								hex4 = B;
								end
					5'b11100: begin
								hex5 = one; 
								hex4 = C;
								end
					5'b11101: begin
								hex5 = one; 
								hex4 = D;
								end
					5'b11110: begin
								hex5 = one; 
								hex4 = E;
								end
					5'b11111: begin
								hex5 = one; 
								hex4 = F;
								end
					default: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								end
					endcase
		end
endmodule

//This module is a testbench for displaying the address as it goes through
//the given input address points and test for if the hex output matches the
//given address value in hex for the 7-seg display board
module addr2_testbench#(parameter addr_width = 5)();
	logic [addr_width - 1:0] addr;
	logic [6:0] hex5, hex4;
	
	//devices under test
	addr2 dut(.addr, .hex5, .hex4);
	
	//initial simulation
	initial begin
		addr=5'b00000;	#10;
		addr=5'b00001;	#10;
		addr=5'b00010;	#10;
		addr=5'b00100;	#10;
		addr=5'b01000;	#10;
		addr=5'b10000;	#10;
		addr=5'b10001;	#10;
		addr=5'b10010;	#10;
		addr=5'b10011;	#10;
		addr=5'b10100;	#10;
		addr=5'b10101;	#10;
		addr=5'b10101;	#10;
		addr=5'b11111;	#10;
		$stop; //end simulation
	end
endmodule

