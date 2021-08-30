//Khoa Tran and Ravi Sangani
//05/14/2020
//Lab 4, Task 1
//This module DE1_SoC controls the logic of inputs from the FPGA using KEY[0] as the reset
//SW[9] as the key to start the program, and SW7-0 as the data input for the datapath and bitcounter
//which together represents a bit counter that counts the number of 1 bit in the input of SW7-0 and display
//the decimal value on the hex0 board display as well as LEDR[9] to indicate the program is done counting.
//This module uses a fsm that controls the state of enabling and loading both B and A in order to increment
//or shift values based on the current state. Using CLOCK_50, bitcounter and datapath works in conjunction to
//count the number of 1 bit in a given data value in binary.
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	input logic CLOCK_50;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	logic LATemp, LBTemp, EATemp, EBTemp;
	logic ZTemp;
	logic [7:0] dataTemp;
	
	//instantiation of bitcounter, outputing LA, LB, EA, EB, and Done, with inputs from datapath for data and Z, as well as KEY[0] for reset and Sw[9] for start
	bitcounter controller(.clk(CLOCK_50), .reset(~KEY[0]), .data(dataTemp), .start(SW[9]), .Z(ZTemp), .LA(LATemp), .LB(LBTemp), .EA(EATemp), .EB(EBTemp), .Done(LEDR[9]));
	//instantiation of datapath, with inputs of LA, LB, EA, and EB from bitcounter, and data from the SW7-0 and outputing on Z, display, and nextData
	datapath data(.clk(CLOCK_50), .LB(LBTemp), .LA(LATemp), .EA(EATemp), .EB(EBTemp), .Z(ZTemp), .data(SW[7:0]), .display(HEX0), .nextData(dataTemp));
	
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
endmodule

//Testing the DE1_SoC module by implementing a series of inputs on KEY[0] as reset,
//SW[9] as start, and SW[7:0] as the data and testing if the outputs of 
//LEDR[9], HEX0 is correct along the posedge CLOCK_50
module DE1_SoC_testbench();
	logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	//device under test
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);

	parameter clock_period = 100;

	 initial begin
		CLOCK_50 <= 0;
		forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50 ;
	 end

	 //initial simulation
	 initial begin
	 KEY[0] <= 0; SW[9] <= 0; SW[7:0] <= 8'd3; @(posedge CLOCK_50);
	 KEY[0] <= 1; SW[9] <= 1; SW[7:0] <= 8'd3; @(posedge CLOCK_50);
	 KEY[0] <= 1; SW[9] <= 1; SW[7:0] <= 8'd3; @(posedge CLOCK_50);
	 KEY[0] <= 1; SW[9] <= 0; SW[7:0] <= 8'd5; @(posedge CLOCK_50);
	 KEY[0] <= 1; SW[9] <= 1; SW[7:0] <= 8'd5; @(posedge CLOCK_50);
	 KEY[0] <= 1; SW[9] <= 1; SW[7:0] <= 8'd5; @(posedge CLOCK_50);
	 KEY[0] <= 1; SW[9] <= 0; SW[7:0] <= 8'd5; @(posedge CLOCK_50);
	 KEY[0] <= 1; SW[9] <= 0; SW[7:0] <= 8'd10; @(posedge CLOCK_50);
	 KEY[0] <= 1; SW[9] <= 1; SW[7:0] <= 8'd10; @(posedge CLOCK_50);
	 KEY[0] <= 1; SW[9] <= 1; SW[7:0] <= 8'd10; @(posedge CLOCK_50);
	 KEY[0] <= 1; SW[9] <= 0; SW[7:0] <= 8'd10; @(posedge CLOCK_50);
	 KEY[0] <= 0; SW[9] <= 0; SW[7:0] <= 8'd10; @(posedge CLOCK_50);
	 $stop;
 end

endmodule
