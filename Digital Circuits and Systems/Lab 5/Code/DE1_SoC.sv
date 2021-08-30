//Khoa Tran
//08/08/2020
//Lab 5
//This module uses the meta, keypress, normalLight, centerLight, winner, counter, compare, and LFSR module
//in order to perform a system designing a game of tug of war against the computer. The game uses KEY[0] and 
//the output from compare to run the game. The output from compare is true when the 10-bit LFSR random value
//output is greater than the input of SW[8:0] with an extra 0 bit on the top.
//The game starts with the centerLight, LEDR[5] to be on acting as the middle of the
//playing field. This is implemented through module centerLight. The rest of the playfield is from LEDR[9] to
//LEDR[1] in order to even the playing field between the users. This is implemented through the normalLight 
//module. The meta and keypress module controlls the user input to allow for metastability with the D-Flip-Flops 
//on the meta module and the keypress controls a hold on the KEY is the same as a press. 
//This game also keeps track of each player's score as the computer or the user. When a player has the score of 7, the
//game resets the scoreboard and starts over. The game also has a reset
//to start the game over with the centerLight being on, the other normalLights off, and the scoreboard back to 0 for both.
//Additionally, implements a 50MHz clock to express the input and output
//whenever the clock on with the positve edge.

//Implementing the DE1_SoC module with the inputs of the FPGA board
//along with instanitiating meta, keypress, normalLight, centerLight, winner, counter, compare, and LSFR 
//module together in order to create the design of the game tug of war against the computer. This module takes in
//the inputs of the FPGA board and outputs to the resulting LEDR. The game uses KEY[0] and 
//the output from compare to run the game. The output from compare is true when the 10-bit LFSR random value
//output is greater than the input of SW[8:0] with an extra 0 bit on the top.
//The game starts with the centerLight, LEDR[5] to be on acting as the middle of the
//playing field. This is implemented through module centerLight. The rest of the playfield is from LEDR[9] to
//LEDR[1] in order to even the playing field between the users. This is implemented through the normalLight 
//module. The meta and keypress module controlls the user input to allow for metastability with the D-Flip-Flops 
//on the meta module and the keypress controls a hold on the KEY is the same as a press. 
//This game also keeps track of each player's score as the computer or the user. When a player has the score of 7, the
//game resets the scoreboard and starts over. 
//The game also has a reset to start the game over with the centerLight being on and the other normalLights off, as
//well as the score to each player as 0.
//Additionally, implements a 768Hz clock to express the input and output
//whenever the clock on with the positve edge.
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	input logic CLOCK_50; // 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	logic [31:0] clk;

	parameter whichClock = 22;

	clock_divider cdiv (CLOCK_50, clk);

	logic reset;  // configure reset

	assign reset = SW[9]; // Reset when SW[9] is on
	
	assign LEDR[0] = clk[whichClock];
	
	//Turns all other lights off (active low property)
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	
	logic combine;
	
	//concatenate SW[8:0] and 1-bit value of 0
	assign combine = {1'b0, SW[8:0]};
	
	logic dFFL; //left output of meta
	logic dFFR; //right output of meta
	
	logic keyL; //left output of keypress
	logic keyR; //right output of keypress
	
	logic leftW; //left winner output from winner
	logic rightW; //right winner output from winner
	
	logic tempReset; //reset of playfield
	
	logic outLFSR; //output of LFSR
	logic press; //output of compare
	
	logic leftRe; //reset output from leftCount
	logic rightRe; //reset output from rightCount
	
	LFSR comp (.clk(clk[whichClock]), .reset(reset), .out(outLFSR));
	compare check (.reset(reset), .In1(combine), .In2(outLFSR), .Gt(press));
	
	//Implements DFF through meta for metastability
	meta mL (.clk(clk[whichClock]), .reset(reset), .temp(tempReset), .d1(press), .q2(dFFL));
	meta mR (.clk(clk[whichClock]), .reset(reset), .temp(tempReset), .d1(KEY[0]), .q2(dFFR));
	
	//Instantiate keypress with inputs from meta and outputs into seperate logic variables
	keypress kL (.clk(clk[whichClock]), .reset(reset), .temp(tempReset), .in(dFFL), .out(keyL));
	keypress kR (.clk(clk[whichClock]), .reset(reset), .temp(tempReset), .in(dFFR), .out(keyR));
	
	//Instantiate 8 normalLight and 1 centerLight with perspective NL and NR as the LEDR on either sides of the LED
	normalLight l4 (.clk(clk[whichClock]), .reset(reset), .temp(tempReset), .L(keyL), .R(keyR), .NL(1'b0), .NR(LEDR[8]), .lightOn(LEDR[9]));
	
	normalLight l3 (.clk(clk[whichClock]), .reset(reset), .temp(tempReset), .L(keyL), .R(keyR), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]));
	
	normalLight l2 (.clk(clk[whichClock]), .reset(reset), .temp(tempReset), .L(keyL), .R(keyR), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]));
	
	normalLight l1 (.clk(clk[whichClock]), .reset(reset), .temp(tempReset), .L(keyL), .R(keyR), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]));
	
	centerLight c (.clk(clk[whichClock]), .reset(reset), .temp(tempReset), .L(keyL), .R(keyR), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]));
	
	normalLight r1 (.clk(clk[whichClock]), .reset(reset), .temp(tempReset), .L(keyL), .R(keyR), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]));
	
	normalLight r2 (.clk(clk[whichClock]), .reset(reset), .temp(tempReset), .L(keyL), .R(keyR), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]));
	
	normalLight r3 (.clk(clk[whichClock]), .reset(reset), .temp(tempReset), .L(keyL), .R(keyR), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]));
	
	normalLight r4 (.clk(clk[whichClock]), .reset(reset), .temp(tempReset), .L(keyL), .R(keyR), .NL(LEDR[2]), .NR(1'b0), .lightOn(LEDR[1]));
	
	winner w (.clk(clk[whichClock]), .reset(reset), .L(keyL), .R(keyR), .loc1(LEDR[9]), .loc2(LEDR[1]), .out1(leftW), .out2(rightW), .temp(tempReset));
	
	counter leftCount (.incr(leftW), .reset(reset), .clk(clk[whichClock]), .display(HEX5), .other(rightRe), .temp(leftRe));
	
	counter rightCount (.incr(rightW), .reset(reset), .clk(clk[whichClock]), .display(HEX0), .other(leftRe), .temp(righRe));
	
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
	
	KEY[0]<=0; SW[0]<=1; @(posedge clk);
	KEY[0]<=0; SW[0]<=1; @(posedge clk);
	KEY[0]<=0; SW[0]<=1; @(posedge clk);
	KEY[0]<=0; SW[0]<=1; @(posedge clk);
	KEY[0]<=0; SW[0]<=1; @(posedge clk);
	KEY[0]<=0; SW[0]<=1; @(posedge clk);
	KEY[0]<=0; SW[0]<=1; @(posedge clk);
	KEY[0]<=0; SW[0]<=1; @(posedge clk);
	KEY[0]<=0; SW[0]<=1; @(posedge clk);
	KEY[0]<=0; SW[0]<=1; @(posedge clk);
	KEY[0]<=0; SW[0]<=1; @(posedge clk);
	KEY[0]<=0; SW[0]<=1; @(posedge clk);
	KEY[0]<=0; SW[0]<=1; @(posedge clk);
	
	$stop;
end

endmodule

// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...

//clock_divider module has inputs of the clock and the
//32 bit divided_clock which allows to sequence through and
//output whenever the postive edge has been reached on the clock 
module clock_divider (clock, divided_clocks);
	input logic clock;
	output logic [31:0] divided_clocks;

	initial begin
		divided_clocks <= 0;
	end

	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
   end

endmodule
