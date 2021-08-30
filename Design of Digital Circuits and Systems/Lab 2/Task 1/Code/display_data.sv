//Khoa Tran
//04/22/2021
//Lab 2, Task 1
//This module controls the logic case for displaying the hex value of the data
//on the hex 7-seg display board. With inputs of data as 4 bits, combinational
//logic through the cases to have the hex output that matches the input data value
module display_data#(parameter data_width = 4) (data, hex);
	input logic [data_width - 1:0] data;
	output logic [6:0] hex;
	
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
	
	//combinational for cases of data values 1-15 to display in hex
	always_comb begin
				case (data)			
					4'b0000: begin
								hex = zero;
								end
					4'b0001: begin
								hex = one;
								end
					4'b0010: begin
								hex = two;
								end
					4'b0011: begin
								hex = three;
								end
					4'b0100: begin
								hex = four;
								end
					4'b0101: begin
								hex = five;
								end
					4'b0110: begin
								hex = six;
								end
					4'b0111: begin
								hex = seven;
								end
					4'b1000: begin
								hex = eight;
								end
					4'b1001: begin
								hex = nine;
								end
					4'b1010: begin
								hex = A;
								end
					4'b1011: begin
								hex = B;
								end
					4'b1100: begin 
								hex = C;
								end
					4'b1101: begin
								hex = D;
								end
					4'b1110: begin 
								hex = E;
								end
					4'b1111: begin
								hex = F;
								end
					default: begin
								hex = 7'b1111111;
								end
					endcase
		end
endmodule

//This module is a testbench for displaying the data as it goes through
//the given input data points and test for if the hex output matches the
//given input value in hex for the 7-seg display board
module display_data_testbench#(parameter data_width = 4)();

	logic [data_width - 1:0] data;
	logic [6:0] hex;
	
	//devices under test
	display_data dut(.data, .hex);
	
	//initial simulation
	initial begin
		data<=4'b0000;	#10;
		data<=4'b0001;	#10;
		data<=4'b0010;	#10;
		data<=4'b0101;	#10;
		data<=4'b1000;	#10;
		data<=4'b0100;	#10;
		data<=4'b0011;	#10;
		data<=4'b0010;	#10;
		data<=4'b0011;	#10;
		data<=4'b0100;	#10;
		data<=4'b0101;	#10;
		data<=4'b0101;	#10;
		data<=4'b1111;	#10;
		
		$stop; //end simulation
	end
endmodule
