//Khoa Tran and Ravi Sangani
//06/07/2020
//Lab 6, Task 1
//This module has inputs of clock, start, up, and down, which are 1 bit in size.
//The outputs are count, hex1, and hex0, which are 5 bits, 7 bits, and 7 bits in size
//respectively. This module outputs a decimal value on the hex display and this value
//can be incremented or decremented.
module controlN(clk, start, up, down, count, hex1, hex0);
	input logic clk, start, up, down;
	output logic [6:0] hex0, hex1;
	output logic [4:0] count;
	
	//This always_ff block handles the logic of incrementing and decrementing the counter
	//based on the boolean inputs up and down.
	always_ff @(posedge clk) begin
		if (start)
			count <= 5'b00000;
		else if (up) 
			count <= count + 1;
		else if (down)
			count <= count - 1;
		else 
			count <= count;
	end
	
	//storing the hex display decimal values into variables for code readibility
	logic [6:0] zero, one, two, three, four, five, six, sevup, eight, nine;
	assign zero = 7'b1000000;
	assign one = 7'b1111001;
	assign two = 7'b0100100;
	assign three = 7'b0110000;
	assign four = 7'b0011001;
	assign five = 7'b0010010;
	assign six = 7'b0000010;
	assign sevup = 7'b1111000;
	assign eight = 7'b0000000;
	assign nine = 7'b0010000;
	
	
	//combinational for cases of out values 0-31
	//This always_comb block handles the logic of 
	//assigning the correct decimal display value to hex1 and hex0,
	//based on the current value of count.
	always_comb begin
				case (count)
					5'b00000: begin
								hex1 = zero;
								hex0 = zero;
								end
					5'b00001: begin
								hex1 = zero;
								hex0 = one;
								end
					5'b00010: begin
								hex1 = zero;
								hex0 = two;
								end
					5'b00011: begin
								hex1 = zero;
								hex0 = three;
								end
					5'b00100: begin
								hex1 = zero;
								hex0 = four;
								end
					5'b00101: begin
								hex1 = zero;
								hex0 = five;
								end
					5'b00110: begin
								hex1 = zero;
								hex0 = six;
								end
					5'b00111: begin
								hex1 = zero;
								hex0 = sevup;
								end
					5'b01000: begin
								hex1 = zero;
								hex0 = eight;
								end
					5'b01001: begin
								hex1 = zero;
								hex0 = nine;
								end
					5'b01010: begin
								hex1 = one;
								hex0 = zero;
								end
					5'b01011: begin
								hex1 = one;
								hex0 = one;
								end
					5'b01100: begin
								hex1 = one;
								hex0 = two;
								end
					5'b01101: begin
								hex1 = one;
								hex0 = three;
								end
					5'b01110: begin
								hex1 = one;
								hex0 = four;
								end
					5'b01111: begin
								hex1 = one;
								hex0 = five;
								end
					5'b10000: begin
								hex1 = one;
								hex0 = six;
								end
					5'b10001: begin
								hex1 = one;
								hex0 = sevup;
								end
					5'b10010: begin
								hex1 = one;
								hex0 = eight;
								end
					5'b10011: begin
								hex1 = one;
								hex0 = nine;
								end
					5'b10100: begin
								hex1 = two;
								hex0 = zero;
								end
					5'b10101: begin
								hex1 = two;
								hex0 = one;
								end
					5'b10110: begin
								hex1 = two;
								hex0 = two;
								end
					5'b10111: begin
								hex1 = two;
								hex0 = three;
								end
					5'b11000: begin
								hex1 = two;
								hex0 = four;
								end
					5'b11001: begin 
								hex1 = two;
								hex0 = five;
								end
					5'b11010: begin 
								hex1 = two;
								hex0 = six;
								end
					5'b11011: begin 
								hex1 = two;
								hex0 = sevup;
								end
					5'b11100: begin 
								hex1 = two;
								hex0 = eight;
								end
					5'b11101: begin 
								hex1 = two;
								hex0 = nine;
								end
					5'b11110: begin 
								hex1 = three;
								hex0 = zero;
								end
					5'b11111: begin 
								hex1 = three;
								hex0 = one;
								end
					default: begin
								hex1 = 7'b1111111;
								hex0 = 7'b1111111;
								end
					endcase
		end
endmodule

//This testbench ensures that the above module works with complete functionality.
//In specific, we test that the count value and hex output display responds as expected to the input booleans of 
//start, up, and down.
module controlN_testbupch();
	logic clk, start, up, down;
	logic [6:0] hex0, hex1;
	logic [4:0] count;
	
	//device under test
	controlN dut(.clk, .start, .up, .down, .count, .hex1, .hex0);
	
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	
	initial begin
		start <= 1; up <= 0; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 0; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 0; down <= 0; @(posedge clk);
		start <= 0; up <= 0; down <= 0; @(posedge clk);
		start <= 0; up <= 0; down <= 0; @(posedge clk);
		start <= 0; up <= 0; down <= 0; @(posedge clk);
		start <= 0; up <= 0; down <= 0; @(posedge clk);
		start <= 0; up <= 0; down <= 0; @(posedge clk);
		start <= 0; up <= 0; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 1; up <= 0; down <= 0; @(posedge clk);
		start <= 0; up <= 0; down <= 1; @(posedge clk);
		start <= 0; up <= 0; down <= 1; @(posedge clk);
		start <= 0; up <= 0; down <= 1; @(posedge clk);
		start <= 0; up <= 0; down <= 1; @(posedge clk);
		start <= 0; up <= 0; down <= 1; @(posedge clk);
		start <= 0; up <= 0; down <= 1; @(posedge clk);
		start <= 0; up <= 0; down <= 1; @(posedge clk);
		start <= 0; up <= 0; down <= 1; @(posedge clk);
		start <= 0; up <= 0; down <= 1; @(posedge clk);
		start <= 0; up <= 0; down <= 1; @(posedge clk);
		start <= 0; up <= 0; down <= 1; @(posedge clk);
		start <= 0; up <= 0; down <= 1; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		start <= 0; up <= 1; down <= 0; @(posedge clk);
		$stop;
	end
endmodule
