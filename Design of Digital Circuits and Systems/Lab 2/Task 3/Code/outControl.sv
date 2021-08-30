//Khoa Tran
//04/22/2021
//Lab 2, Task 3
//This module controls the logic case for displaying the hex value of the output data
//on the hex 7-seg display board. With inputs of data as 4 bits and the switch,
//combinational logic through the cases to have the hex output that matches the input data value
//and the switch, only outputing an actual hex display value if switch is true. Else, the output
//display will be value that shows nothing.
module outControl#(parameter data_width = 4)(data, hex, switch);
	input logic [data_width - 1:0] data;
	input logic switch;
	output logic [6:0] hex;
	
	//logic for nothing to zero to 15 with hex display value assigned
	logic [6:0] nothing, zero, one, two, three, four, five, six, seven, eight, nine, A, B, C, D, E, F;
	assign nothing = 7'b1111111;
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
	
	//combinational for cases of data and switch concatenated together
	always_comb begin
				case ({data, switch})			
					5'b00000: begin
								hex = nothing;
								end
					5'b00001: begin
								hex = zero;
								end
					5'b00011: begin
								hex = one;
								end
					5'b00101: begin
								hex = two;
								end
					5'b00111: begin
								hex = three;
								end
					5'b01001: begin
								hex = four;
								end
					5'b01011: begin
								hex = five;
								end
					5'b01101: begin
								hex = six;
								end
					5'b01111: begin
								hex = seven;
								end
					5'b10001: begin
								hex = eight;
								end
					5'b10011: begin
								hex = nine;
								end
					5'b10101: begin
								hex = A;
								end
					5'b10111: begin
								hex = B;
								end
					5'b11001: begin 
								hex = C;
								end
					5'b11011: begin
								hex = D;
								end
					5'b11101: begin 
								hex = E;
								end
					5'b11111: begin
								hex = F;
								end
					default: begin
								hex = 7'b1111111;
								end
					endcase
		end
endmodule

//This module is a testbench for outputing data by passing in
//a series of data inputs and switch inputs and testing if
//the hex output is correct
module outControl_testbench#(parameter data_width = 4)();

	logic [data_width - 1:0] data;
	logic [6:0] hex;
	logic switch;
	
	//devices under test
	outControl dut(.data, .hex, .switch);
	
	//initial simulation
	initial begin
		data<=4'b0000; switch<=0; #10;
		data<=4'b0000; switch<=1; #10;
		data<=4'b0001;	switch<=1; #10;
		data<=4'b0010;	switch<=1; #10;
		data<=4'b0101;	switch<=1; #10;
		data<=4'b1000;	switch<=1; #10;
		data<=4'b0100;	switch<=1; #10;
		data<=4'b0011;	switch<=1; #10;
		data<=4'b0010;	switch<=1; #10;
		data<=4'b0011;	switch<=1; #10;
		data<=4'b0100;	switch<=1; #10;
		data<=4'b0101;	switch<=1; #10;
		data<=4'b0101;	switch<=1; #10;
		data<=4'b1111;	switch<=1; #10;
		$stop; //end simulation
	end
endmodule
