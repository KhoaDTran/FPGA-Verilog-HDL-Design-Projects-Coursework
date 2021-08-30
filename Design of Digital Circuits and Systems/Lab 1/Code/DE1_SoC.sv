//Khoa Tran
//04/12/2021
//CSE 371
//Lab 1, DE1_SoC Task3 
//This module, DE1_SoC takes the inout swtiches of the GPIO_0, Clock_50 input,
//in order to have the switches be connected to the LED on the breadboard. These
//switches are connected to the fsm of the parking lot problem, as the first GPIO
//switch is connected to input a, and the other switch connected to input b.
//From these inputs, the fsm will output a value for the counter to either increment
//or decrement. Afterwards, the output of the counter indicates the amount of cars in the parking
//lot, displaying the values on the hex 7-segment display. The reset is connected to
//the third switch on the breadboard, allowing the state of the parking lot to go back
//to zero cars. Additionally, implements a clock that is connected to LEDR[5] and will
//express the input whenever the clock, and led is on with the positve edge.
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, GPIO_0);
	input logic CLOCK_50; // 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	
	inout logic [33:0] GPIO_0;
	
	
	logic reset;
	logic [31:0] div_clk;

	assign reset = GPIO_0[7]; //third switch connected to reset
	parameter whichClock = 22; // 0.75 Hz clock
	
	assign GPIO_0[26] = GPIO_0[5]; //connecting switches to leds
	assign GPIO_0[27] = GPIO_0[6];
	
	clock_divider cdiv (.clock(CLOCK_50), .reset(reset), .divided_clocks(div_clk));

	logic clkSelect;

	assign clkSelect = CLOCK_50; // for simulation
	
	//assign clkSelect = div_clk[whichClock]; // for board
	
	//LEDR[0] connected to clk
	assign LEDR[0] = clkSelect;
	
	// logic variables for output of fsm
	logic enterOut;
	logic exitOut;
	
	fsm parking(.clk(clkSelect), .reset(reset), .a(GPIO_0[5]), .b(GPIO_0[6]), .enter(enterOut), .exit(exitOut));
	//output of fsm goes into counter for count and display of values
	counter count(.incr(enterOut), .decr(exitOut), .reset(reset), .clk(clkSelect), .display(HEX0), .hex1(HEX1), .hex2(HEX2), .hex3(HEX3), .hex4(HEX4), .hex5(HEX5));
	
	
endmodule

//Module test the output of the DE1_SoC module by running a sequence of inputs
//on the switches on the GPIO[5] and GPIO[6] and GPIO[7] as the reset 
//in order to test if the output on the HEX0, HEX1, HEX2, HEX3, HEX4, and HEX5
//is correct along the positive edges.
module DE1_SoC_testbench();
	logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	wire [33:0] GPIO_0;
	logic Sw0, Sw1, reset;
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .LEDR, .GPIO_0);
	
	assign GPIO_0[5] = Sw0;
	assign GPIO_0[6]= Sw1;
	assign GPIO_0[7] = reset;
	
	parameter clock_period = 100;
		
		initial begin
			CLOCK_50 <= 0;
			forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
					
		end //initial
	

	initial begin
		 reset <= 1; @(posedge CLOCK_50);
		 reset <= 0; @(posedge CLOCK_50);

		 Sw0 <= 0; Sw1 <= 0; @(posedge CLOCK_50);
		 Sw0 <= 1; Sw1 <= 0; @(posedge CLOCK_50);
		 Sw0 <= 1; Sw1 <= 1; @(posedge CLOCK_50);
		 Sw0 <= 0; Sw1 <= 1; @(posedge CLOCK_50);
		 Sw0 <= 0; Sw1 <= 0; @(posedge CLOCK_50);
		 Sw0 <= 1; Sw1 <= 0; @(posedge CLOCK_50);
		 Sw0 <= 1; Sw1 <= 1; @(posedge CLOCK_50);
		 Sw0 <= 0; Sw1 <= 1; @(posedge CLOCK_50);
		 Sw0 <= 0; Sw1 <= 0; @(posedge CLOCK_50);
		 Sw0 <= 0; Sw1 <= 1; @(posedge CLOCK_50);
		 Sw0 <= 1; Sw1 <= 1; @(posedge CLOCK_50);
		 Sw0 <= 1; Sw1 <= 0; @(posedge CLOCK_50);
		 Sw0 <= 0; Sw1 <= 0; @(posedge CLOCK_50);
		 Sw0 <= 0; Sw1 <= 0; @(posedge CLOCK_50);
	
	$stop;
end

endmodule

//clock_divider module has inputs of the clock, reset, and the
//32 bit divided_clock which allows to sequence through and
//output whenever the postive edge has been reached on the clock 
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, reset, divided_clocks);
	input logic reset, clock;
	output logic [31:0] divided_clocks = 0;

	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end

endmodule
