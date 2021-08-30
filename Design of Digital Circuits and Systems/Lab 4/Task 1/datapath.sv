//Khoa Tran and Ravi Sangani
//05/14/2020
//Lab 4, Task 1
//Module datapath implements a datapath logic of a shifter and a counter, incrementing
//shifting and loading the data based on the inputs of LB, LA, EA, EB, and data
//These inputs are from the fsm indicating when the datapath should increment B or load B
//or load A or shift A. Outputs of Z is for if the data value is shifted and equals to 0 to stop
//counting, as well as display and nextData for the data output and the hex display
//equivalent value.
module datapath(clk, LB, LA, EA, EB, Z, data, display, nextData);
	input logic clk, LB, LA, EA, EB;
	input logic [7:0] data;
	output logic [7:0] nextData;
	
	output logic [6:0] display;
	output logic Z;
	
	//registers holding hex display value for each decimal equivalent
	logic [3:0] B;
	logic [6:0] zero, one, two, three, four, five, six, seven, eight;
	assign zero = 7'b1000000;
	assign one = 7'b1111001;
	assign two = 7'b0100100;
	assign three = 7'b0110000;
	assign four = 7'b0011001;
	assign five = 7'b0010010;
	assign six = 7'b0000010;
	assign seven = 7'b1111000;
	assign eight = 7'b0000000;
	
	//sequential logic loading B, enabling B, loading A, and enabling A for shifting
	always_ff @(posedge clk)
		begin
			if (LB) B <= 0;
			//increment B if enable B
			if (EB) B <= B + 1;
			if (LA) nextData <= data;
			//shift data if enable A
			if (EA) nextData <= nextData>>1;
		end
	
	assign Z = (nextData == 0);
	
	//combinational logic for different cases of B to display the value on the hex board
	always_comb begin
				case (B)			
					4'b0000: begin
								display = zero;
								end
					4'b0001: begin
								display = one;
								end
					4'b0010: begin
								display = two;
								end
					4'b0011: begin
								display = three;
								end
					4'b0100: begin
								display = four;
								end
					4'b0101: begin
								display = five;
								end
					4'b0110: begin
								display = six;
								end
					4'b0111: begin
								display = seven;
								end
					4'b1000: begin
								display = eight;
								end
					default: begin
								display = 7'b1111111;
								end
					endcase
		end
endmodule

//module datapath_testbench is a testbench for datapath
//setting a series of inputs on LB, EB, LA, EA, and data, in order
//to test the output of nextData, display, and Z on the posedge clk
module datapath_testbench();
	logic clk, LB, LA, EA, EB;
	logic [7:0] data;
	logic [7:0] nextData;
	
	logic [6:0] display;
	logic Z;
	
	//device under test
	datapath path(.clk, .LB, .LA, .EA, .EB, .Z, .data, .display, .nextData);
	
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	
	//initial simulation
	initial begin
		LB<=0; data<=8'd5; LA<= 0; EB<=0; EA<=0; @(posedge clk);
		LB<=0; data<=8'd5; LA<= 1; EB<=0; EA<=0; @(posedge clk);
		LB<=0; data<=8'd5; LA<= 1; EB<=0; EA<=1; @(posedge clk);
		LB<=1; data<=8'd5; LA<= 1; EB<=0; EA<=1; @(posedge clk);
		LB<=0; data<=8'd5; LA<= 0; EB<=1; EA<=1; @(posedge clk);
		LB<=0; data<=8'd5; LA<= 0; EB<=1; EA<=1; @(posedge clk);
		LB<=0; data<=8'd5; LA<= 0; EB<=1; EA<=1; @(posedge clk);
		LB<=0; data<=8'd5; LA<= 0; EB<=1; EA<=1; @(posedge clk);
		$stop;
		
	end
endmodule
