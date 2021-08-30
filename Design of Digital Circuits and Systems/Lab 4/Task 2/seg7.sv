//Khoa Tran and Ravi Sangani
//05/14/2020
//Lab 4, Task 2
//Module seg7 controls the output to the hex1 and hex0 display based on inputs of found
//and address as if found is 0, then output to the display nothing, but if it is found,
//then output the value of the address in hexadecimal equivalent on the hex1 and hex0 display.
module seg7(addr, found, hex5, hex4);
	input logic [4:0] addr;
	input logic found;
	
	output logic [6:0] hex5, hex4;
	
	//logic of hex display values equivalent to hexadecimal value
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
	
	//combinational logic of outputing hex5, and hex4 based on found condition and cases of addr
	always_comb begin
		if (~found) begin
		    hex5 = 7'b1111111;
		    hex4 = 7'b1111111;
		end
		else begin
		
		case(addr)
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
		end
		
endmodule

//Module seg7_testbench is a testbench for seg7 testing the outputs of 
//hex5 and hex4 is correct based on the given inputs of addr and found
module seg7_testbench();
	logic [4:0] addr;
	logic found;
	
	logic [6:0] hex5, hex4;
	
	//instatiation of seg7
	seg7 disp(.addr, .found, .hex5, .hex4);
	
	initial begin
		addr=5'd0;	found = 0; #10;
		addr=5'd2;	found = 0; #10;
		addr=5'd3;	found = 0; #10;
		addr=5'd4;	found = 0; #10;
		addr=5'd5;	found = 0; #10;
		addr=5'd2;	found = 1; #10;
		addr=5'd3;	found = 1; #10;
		addr=5'd4;	found = 1; #10;
		addr=5'd5;	found = 1; #10;	
		$stop; //end simulation
	end
endmodule
	
