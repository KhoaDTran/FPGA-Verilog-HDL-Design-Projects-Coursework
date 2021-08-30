//Khoa Tran
//07/29/2020
//Lab 4
//This module uses the meta, keypress, normalLight, centerLight, and winner module
//in order to perform a system designing a game of tug of war. The game uses KEY[0] and KEY[3] 
//as inputs for the user. The game starts with the centerLight, LEDR[5] to be on acting as the middle of the
//playing field. This is implemented through module centerLight. The rest of the playfield is from LEDR[9] to
//LEDR[1] in order to even the playing field between the users. This is implemented through the normalLight 
//module. The meta and keypress module controlls the user input to allow for metastability with the D-Flip-Flops 
//on the meta module and the keypress controls a hold on the KEY is the same as a press. The game also has a reset
//to start the game over with the centerLight being on and the other normalLights off.
//Additionally, implements a 50MHz clock to express the input and output
//whenever the clock on with the positve edge.

//Implementing the DE1_SoC module with the inputs of the FPGA board
//along with instanitiating meta, keypress, normalLight, centerLight, and winner 
//module together in order to create the design of the game tug of war.
//The game also has a reset to start the game over with the centerLight being on and the other normalLights off.
//Additionally, implements a 50MHz clock to express the input and output
//whenever the clock on with the positve edge.
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	input logic CLOCK_50; // 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;


	logic reset;  // configure reset

	assign reset = SW[9]; // Reset when SW[9] is on
	
	assign LEDR[0] = CLOCK_50;
	
	//Turns all other lights off (active low property)
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
	logic dFFL; //left output of meta
	logic dFFR; //right output of meta
	
	logic keyL; //left output of keypress
	logic keyR; //right output of keypress
	
	//Implements DFF through meta for metastability
	meta mL (.clk(CLOCK_50), .reset(reset), .d1(KEY[3]), .q2(dFFL));
	meta mR (.clk(CLOCK_50), .reset(reset), .d1(KEY[0]), .q2(dFFR));
	
	//Instantiate keypress with inputs from meta and outputs into seperate logic variables
	keypress kL (.clk(CLOCK_50), .reset(reset), .in(dFFL), .out(keyL));
	keypress kR (.clk(CLOCK_50), .reset(reset), .in(dFFR), .out(keyR));
	
	//Instantiate 8 normalLight and 1 centerLight with perspective NL and NR as the LEDR on either sides of the LED
	normalLight l4 (.clk(CLOCK_50), .reset(reset), .L(keyL), .R(keyR), .NL(1'b0), .NR(LEDR[8]), .lightOn(LEDR[9]));
	
	normalLight l3 (.clk(CLOCK_50), .reset(reset), .L(keyL), .R(keyR), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]));
	
	normalLight l2 (.clk(CLOCK_50), .reset(reset), .L(keyL), .R(keyR), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]));
	
	normalLight l1 (.clk(CLOCK_50), .reset(reset), .L(keyL), .R(keyR), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]));
	
	centerLight c (.clk(CLOCK_50), .reset(reset), .L(keyL), .R(keyR), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]));
	
	normalLight r1 (.clk(CLOCK_50), .reset(reset), .L(keyL), .R(keyR), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]));
	
	normalLight r2 (.clk(CLOCK_50), .reset(reset), .L(keyL), .R(keyR), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]));
	
	normalLight r3 (.clk(CLOCK_50), .reset(reset), .L(keyL), .R(keyR), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]));
	
	normalLight r4 (.clk(CLOCK_50), .reset(reset), .L(keyL), .R(keyR), .NL(LEDR[2]), .NR(1'b0), .lightOn(LEDR[1]));
	
	winner w (.clk(CLOCK_50), .reset(reset), .L(keyL), .R(keyR), .loc1(LEDR[9]), .loc2(LEDR[1]), .out(HEX0));
	
endmodule

//Module test the output of the DE1_SoC module by running a sequence of inputs
//on KEY[3] and KEY[0] and SW[9] as the reset 
//in order to test if the output on the LEDR and HEX0, is correct along
//the positive edges.
module DE1_SoC_testbench();

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic clk;
	parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end //initial
	
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);

	initial begin
	
	KEY[3]<=1; KEY[0]<=0; SW[9]<=0; @(posedge clk);
	KEY[3]<=1; KEY[0]<=0; SW[9]<=0; @(posedge clk);
	KEY[3]<=1; KEY[0]<=0; SW[9]<=0; @(posedge clk);
	KEY[3]<=1; KEY[0]<=0; SW[9]<=0; @(posedge clk);
	KEY[3]<=0; KEY[0]<=0; SW[9]<=1; @(posedge clk);
	KEY[3]<=0; KEY[0]<=1; SW[9]<=0; @(posedge clk);
	KEY[3]<=0; KEY[0]<=1; SW[9]<=0; @(posedge clk);
	KEY[3]<=1; KEY[0]<=0; SW[9]<=0; @(posedge clk);
	KEY[3]<=1; KEY[0]<=0; SW[9]<=0; @(posedge clk);
	KEY[3]<=0; KEY[0]<=1; SW[9]<=0; @(posedge clk);
	KEY[3]<=0; KEY[0]<=1; SW[9]<=0; @(posedge clk);
	KEY[3]<=0; KEY[0]<=1; SW[9]<=0; @(posedge clk);
	KEY[3]<=0; KEY[0]<=1; SW[9]<=0; @(posedge clk);
	
	$stop;
end

endmodule
