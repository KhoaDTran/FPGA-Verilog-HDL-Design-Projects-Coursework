//Khoa Tran
//04/22/2021
//Lab 2, Task 2
//This module implements a rdaddresser that increments by 1 at every posedge
//clk, if there's a reset, then the rdaddress goes back to 0.
//As the module takes input reset, clk, and outputs rdaddress.
module counter#(parameter width = 5) (reset, clk, rdaddress, hex5, hex4);
	input logic reset, clk; //input reset, and clk
	output logic [width - 1:0] rdaddress;
	output logic [6:0] hex5, hex4;
	
	//sequential (DFFS) increment rdaddress or if reset, rdaddress goes back to 0
	always_ff @(posedge clk) begin
			if (reset)
				rdaddress <= 5'b00000;
			else
				rdaddress <= rdaddress + 5'b00001;
		end
	
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
				case (rdaddress)			
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

//Module test the output of the rdaddresser module by running a sequence of inputs
//on reset if the output of rdaddress is incrementing at each posedge clk
module counter_testbench#(parameter width = 5)();

	logic reset, clk; 
	logic [width - 1:0] rdaddress;
	logic [6:0] hex5, hex4;
	
	//devices under test
	counter dut (.reset, .clk, .rdaddress, .hex5, .hex4);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	//initial simulation
	initial begin
		reset <= 1;				@(posedge clk);
		reset <= 0; 			@(posedge clk);
		reset <= 0; 			@(posedge clk);
		reset <= 0; 			@(posedge clk);
		reset <= 0; 			@(posedge clk);
		reset <= 0; 			@(posedge clk);
		reset <= 0; 			@(posedge clk);
		reset <= 0; 			@(posedge clk);
		reset <= 0; 			@(posedge clk);
		reset <= 0; 			@(posedge clk);
		reset <= 0; 			@(posedge clk);
		reset <= 0; 			@(posedge clk);
		reset <= 0; 			@(posedge clk);
		
		$stop; //end simulation
	end
endmodule
		