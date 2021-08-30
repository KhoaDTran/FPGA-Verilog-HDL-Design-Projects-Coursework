//Khoa Tran
//05/07/2021
//Lab 3, Task 2
//Module DE1_SoC that instantiates line_drawer and fsm for VGA_framebuffer
//as line_drawer is a module that takes inputs from fsm in order to output
//x and y values to the VGA_framebuffer. The fsm controller outputs color
//as well as resetOut for line drawer to start at initial value and VGA_framebuffer
//to set the color. The fsm module goes through a series of states to 
//manipulate the line_drawer to animate a line going through the display in a circle
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;

	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR = SW;
	
	logic [9:0] x0Out, x1Out, xOut;
	logic [9:0] y0Out, y1Out, yOut;
	logic frame_start;
	logic colorOut;
	logic [9:0] x;
	logic [8:0] y;
	
   logic [31:0] div_clk;
	logic pixelcolor;
	parameter whichClock = 10;
	clock_divider cdiv (.clock(CLOCK_50 ), .divided_clocks (div_clk ));
	logic clkSelect;
	assign clkSelect = div_clk[whichClock];
	
	//////// DOUBLE_FRAME_BUFFER ////////
	logic dfb_en;
	assign dfb_en = 1'b0;
	/////////////////////////////////////
	
	logic tempResets;
	logic doneChecker;
	
	//instatiation of VGA_framebuffer colorOut 
	VGA_framebuffer fb(.clk(CLOCK_50), .rst(1'b0), .x(xOut), .y(yOut), .pixel_color(colorOut), .pixel_write(1'b1), .dfb_en, .frame_start, .VGA_R, .VGA_G, .VGA_B, .VGA_CLK, .VGA_HS, .VGA_VS, .VGA_BLANK_N, .VGA_SYNC_N);
	
	//instatiation of fsm for setting values of line_drawer in order to animate a line and send a color to VGA_framebuffer and coordinates for the line_drawer
	//fsm controller (.check(doneChecker), .clear(SW[1]), .clk(clkSelect), .reset(SW[0]), .x0next(x0Out), .x1next(x1Out), .y0next(y0Out), .y1next(y1Out), .color(colorOut), .resetOut(tempResets));
	
	// instantiation of line_drawer passing in x0, x1, y0, y1, and outputting a series of x and y outputs for VGA_framebuffer and done for fsm
	line_drawer lin4es (.clk(CLOCK_50), .reset(SW[0]), .x0(x0Out), .x1(x1Out), .y0(y0Out), .y1(y1Out), .x, .y); //.tempReset(tempResets), .x0(x0Out), .x1(x1Out), .y0(y0Out), .y1(y1Out), .x, .y, .done(doneChecker));
	
	
	//uncomment below for task 1 
	// draw an arbitrary line
	assign x0Out = 10'd100;
	assign y0Out = 9'd100;
	assign x1Out = 10'd240;
	assign y1Out = 9'd240;
//	
//	//initial colorOut = 1'b0;
	always_ff @(posedge CLOCK_50) 
		begin
			if (SW[0]) colorOut <= 1'b1;
			else colorOut <= 1'b0;
		end
	
endmodule

//Module test the output of the DE1_SoC module by running a sequence of inputs
//on the switches that controls the reset of fsm and line_drawer and seeing if
//the x and y output is correct along the posedge CLOCK_50 based on different states
//that the fsm outputs.
module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;

	logic CLOCK_50;
	logic [7:0] VGA_R;
	logic [7:0] VGA_G;
	logic [7:0] VGA_B;
	logic VGA_BLANK_N;
	logic VGA_CLK;
	logic VGA_HS;
	logic VGA_SYNC_N;
	logic VGA_VS;
	
	//device under test of DE1_SoC
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW, .CLOCK_50, 
		.VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N, .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
	
	
	parameter clock_period = 100;
		
		initial begin
			CLOCK_50 <= 0;
			forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
					
		end 
		
	//initial
	initial begin
		 SW[0] <= 1; @(posedge CLOCK_50);
		 SW[0] <= 0; @(posedge CLOCK_50);
		 repeat(1000)   @(posedge CLOCK_50);
	
	$stop;
end

endmodule

//clock_divider module has inputs of the clock, reset, and the
//32 bit divided_clock which allows to sequence through and
//output whenever the postive edge has been reached on the clock
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks );
	input logic clock;
	output logic [31:0] divided_clocks = 0;

	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end
endmodule
