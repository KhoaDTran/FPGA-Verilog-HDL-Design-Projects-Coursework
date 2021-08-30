//Khoa Tran
//04/12/2021
//CSE 371
//Lab 1, Counter Task 2
//This module implements a sequential circuit that acts as a register
//that goes through a specific state sequence. In this module, it is a
//counter that has a specific n-bit size, and counts from 0 to 2^(n-1)
//in binary. This module counts upwards at positive clock edge. This 
//module allows reset to make the output go back to 0 when reset is called.
//As the counter increases or decreases, the 7-bit values for the display of hex0
//to hex5 is given in a combinational circuit in order to display the current 
//number of cars in the parking lot. At 0 cars, the display is "CLEAr0" and at 25
//cars, it displays "FULL25". For all other values, it will just display the value.

//Implements counter module with input incr, decr, reset, clk, display, hex1, hex2,
//hex3, hex4, and hex5, along with a parameter to initialize the n-bit size desired. 
//The output variable is display and hex1 through hex5, which are the outputs
//to the display on the 7-segment HEX board as it shows the current count of cars 
//incrementing when incr is 1 and decrementing when decr is 1. This module counts from 0 to 2^(n-1)
//in binary and counts upwards at positive clock edge. This 
//module allows reset to make the output go back to 0 when reset is called. As the counter's count
//increase or decrease, the display outputs the 7-bit binary output for the HEX board
//displaying the current digital value. When the binary value equals 25,
//the parking lot is full and shows a message displaying that.
module counter #(parameter width = 5) (incr, decr, reset, clk, display, hex1, hex2, hex3, hex4, hex5);
	logic [width - 1:0] out; //current value
	input logic incr, decr, reset, clk; //input incr, decr, reset, and clk
	output logic [6:0] display; //outputs for HEX0-5
	output logic [6:0] hex1;
	output logic [6:0] hex2;
	output logic [6:0] hex3;
	output logic [6:0] hex4;
	output logic [6:0] hex5;
	
	//7-seg hex display for values zero through nine
	logic [6:0] zero, one, two, three, four, five, six, seven, eight, nine;
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
	
	//sequential (DFFS) incr and decr out
	always_ff @(posedge clk)
	begin
		if (reset)
			out <= 0;
		else if (incr)
			out <= out + 1;
		else if (decr)
			out <= out - 1;
	end
	
	//combinational for cases of out values 1-25
	always_comb begin
				case (out)			
					5'b00000: begin //0 (CLEAR0)
								hex5 = 7'b1000110;
								hex4 = 7'b1000111;
								hex3 = 7'b0000110;
								hex2 = 7'b0001000;
								hex1 = 7'b0101111;
								display = zero;
								end
					5'b00001: begin
								hex5 = 7'b1111111;
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = zero;
								display = one;
								end
					5'b00010: begin
								hex5 = 7'b1111111;
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = zero;
								display = two;
								end
					5'b00011: begin
								hex5 = 7'b1111111;
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = zero;
								display = three;
								end
					5'b00100: begin
								hex5 = 7'b1111111;
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = zero;
								display = four;
								end
					5'b00101: begin
								hex5 = 7'b1111111;
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = zero;
								display = five;
								end
					5'b00110: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = zero;
								display = six;
								end
					5'b00111: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = zero;
								display = seven;
								end
					5'b01000: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = zero;
								display = eight;
								end
					5'b01001: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = zero;
								display = nine;
								end
					5'b01010: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = one;
								display = zero;
								end
					5'b01011: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = one;
								display = one;
								end
					5'b01100: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = one;
								display = two;
								end
					5'b01101: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = one;
								display = three;
								end
					5'b01110: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = one;
								display = four;
								end
					5'b01111: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = one;
								display = five;
								end
					5'b10000: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = one;
								display = six;
								end
					5'b10001: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = one;
								display = seven;
								end
					5'b10010: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = one;
								display = eight;
								end
					5'b10011: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = one;
								display = nine;
								end
					5'b10100: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = two;
								display = zero;
								end
					5'b10101: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = two;
								display = one;
								end
					5'b10110: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = two;
								display = two;
								end
					5'b10111: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = two;
								display = three;
								end
					5'b11000: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = two;
								display = four;
								end
					5'b11001: begin //25 (FULL25)
								hex5 = 7'b0001110;
								hex4 = 7'b1000001;
								hex3 = 7'b1000111;
								hex2 = 7'b1000111;
								hex1 = two;
								display = five;
								end
					default: begin
								hex5 = 7'b1111111; 
								hex4 = 7'b1111111;
								hex3 = 7'b1111111;
								hex2 = 7'b1111111;
								hex1 = 7'b1111111;
								display = 7'b1111111;
								end
					endcase
		end
endmodule

//Module test the output of the counter module by running a sequence of inputs
//on reset, incr and decr to test if the output of display, hex1, hex2, hex3, hex4, and hex5.
//is correct along the positive edges, by making sure out counts up by 1 when incr is 1 and 
//decrements when decr is 1.
module counter_testbench#(parameter width = 5)();

	logic incr, decr, reset, clk; 
	logic [6:0] display;
	logic [6:0] hex1;
	logic [6:0] hex2; 
	logic [6:0] hex3; 
	logic [6:0] hex4; 
	logic [6:0] hex5;
	logic [width - 1:0] out;
	
	//devices under test
	counter dut (.incr, .decr, .reset, .clk, .display, .hex1, .hex2, .hex3, .hex4, .hex5);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	//initial simulation
	initial begin
		reset <= 1;									@(posedge clk);
		reset <= 0; incr<=0; decr<=0;			@(posedge clk);
		reset <= 0; incr<=1; decr<=0;			@(posedge clk);
		reset <= 0; incr<=1; decr<=0;			@(posedge clk);
		reset <= 0; incr<=1; decr<=0;			@(posedge clk);
		reset <= 0; incr<=1; decr<=0;			@(posedge clk);
		reset <= 0; incr<=1; decr<=0;			@(posedge clk);
		reset <= 0; incr<=0; decr<=1;			@(posedge clk);
		reset <= 0; incr<=0; decr<=1;			@(posedge clk);
		reset <= 0; incr<=0; decr<=1;			@(posedge clk);
		reset <= 0; incr<=0; decr<=1;			@(posedge clk);
		reset <= 0; incr<=0; decr<=1;			@(posedge clk);
		reset <= 0; incr<=0; decr<=1;			@(posedge clk);
		
		$stop; //end simulation
	end
endmodule
		