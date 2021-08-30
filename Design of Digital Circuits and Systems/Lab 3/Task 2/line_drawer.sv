//Khoa Tran
//05/07/2021
//Lab 3, Task 1
//This module implements a controller for the VGA_framebuffer that draws a line from inputs 
//of x0, y0, x1, y1 as two coordinates and outputs a series of x and y addresses of the VGA_framebuffer
//and output of done indicating the line is done printing. Taking inputs of clk and reset for 
//making sure that values are given to the output at the posedge clk as well as having a functionality
//to reset or tempReset input from the fsm as an indication that the line has been cleared.
module line_drawer(clk, reset, tempReset, x0, x1, y0, y1, x, y, done);
	input logic clk, reset;
	input logic tempReset;
	
	input logic [9:0]	x0, x1; 
	input logic [8:0] y0, y1;

	output logic [9:0] x;
	output logic [8:0] y;
	output logic done;
	logic doneTemp, doneNext;
	
	
	logic [9:0] dx, dxVal, xfirst, xlast;
	logic [8:0] dy, dyVal, yfirst, ylast;
	logic signed [11:0] error, errorVal, errorNext, errorTemp;
	logic [9:0] xVal, xNext, xFinal;
	logic [8:0] yVal, yNext, ystep, yFinal;
	logic steep;
	
	//combinational logic for setting temporary variables for outputs
	always_comb begin
		//calc of absolute value of delta x and delta y
		dxVal = (x1 > x0) ? (x1 - x0) : (x0 - x1);
		dyVal = (y1 > y0) ? (y1 - y0) : (y0 - y1);
		//logic stating if line is steep or not
		steep = (dyVal > dxVal);
		
		//logic assigning xfirst, xlast, yfirst, ylast to x0,x1,y0,y1 based on conditions of steep and which value is bigger
		xfirst = (~steep & (x0>x1)) ? x1 : (~steep & ~(x0>x1)) ? x0 : (steep & (y0>y1)) ? y1: y0;
		xlast = (~steep & (x0>x1)) ? x0: (~steep & ~(x0>x1)) ? x1: (steep & (y0>y1)) ? y0: y1;
		yfirst = (~steep & (x0>x1)) ? y1: (~steep & ~(x0>x1)) ? y0: (steep & (y0>y1)) ? x1: x0;
		ylast = (~steep & (x0>x1)) ? y0: (~steep & ~(x0>x1)) ? y1: (steep & (y0>y1)) ? x0: x1;
		
		//setting dx and dy based on steep or not
		dx = steep ? dyVal : dxVal;
		dy = steep ? dxVal : dyVal;
		
		//initial error value
		errorTemp = -(dx/2);
		
		//logic of ystep based on if ylast is bigger than yfirst
		ystep = (yfirst < ylast) ? 1: -1;
		
		//logic of for loop, incrementing x values and y values based on error
		xNext = xVal + 1'b1;
		errorVal = error + dy;
		yNext = (errorVal >= 0) ? yVal + ystep: yVal;
		errorNext = (errorVal >= 0) ? errorVal - dx: errorVal;
		
		//output yFinal and xFinal based on steep or not
		yFinal = steep ? xVal : yVal;
		xFinal = steep ? yVal : xVal;
		
		//logic for outputting done based on conditions of being at the endpoint
		doneTemp = (xlast == xVal && ylast == yVal) ? 1 : 0;
		doneNext = (reset || tempReset) ? 0 : doneTemp;
		
	end
	
	//sequential logic setting next x and y values to the variables in combinational logic for changes and updates
	always_ff @(posedge clk)
		begin
			if (reset || tempReset)
				begin
					//on reset, set current values to the starting point based on combinational logic
					xVal <= xfirst;
					yVal <= yfirst;
					error <= errorTemp;
					done <= doneNext;
				end
			else
			begin
					//stopping condition
					if (xlast == xVal && ylast == yVal)					
						begin
							xVal <= xVal;
							yVal <= yVal;
							error <= error;
							done <= doneNext;
						end
					else 
					//set next values to current
						begin
							xVal <= xNext;
							yVal <= yNext;
							error <= errorNext;
							done <= doneNext;
						end
				end
			//setting output of x and y
			x <= xFinal;
			y <= yFinal;
		end			
	
endmodule

//Module testbench for line_drawer testing if outputs on x and y are correct
//along the posedge clk of inputs x0, y0, x1, y1 by passing a series of inputs
//and seeing if the output is correct
module line_drawer_testbench();
	logic clk, reset;
	logic tempReset;
	
	logic [9:0]	x0, x1; 
	logic [8:0] y0, y1;

	logic [9:0] x;
	logic [8:0] y;
	logic done;
	
	//line_drawer device under test
	line_drawer dut(.clk, .reset, .tempReset, .x0, .x1, .y0, .y1, .x, .y, .done);
	
	parameter clock_period = 100;
	
	//initial
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	
	initial begin
		x0 <= 10'd100; x1 <= 10'd240;
	   y0 <= 9'd100; y1 <= 9'd240;
	   reset <= 1;                                   @(posedge clk);
	   reset <= 0;                                   @(posedge clk);                           	

		repeat(50)                                     @(posedge clk);
		
		x0 <= 10'd10; x1 <= 10'd500;
	   y0 <= 9'd10; y1 <= 9'd400;
		reset <= 1;                                   @(posedge clk);
	   reset <= 0;                                   @(posedge clk);                           	

		repeat(500)                                     @(posedge clk);
		
		x0 <= 10'd10; x1 <= 10'd500;
	   y0 <= 9'd400; y1 <= 9'd10;
		reset <= 1;                                   @(posedge clk);
	   reset <= 0;                                   @(posedge clk);                           	

		repeat(500)                                     @(posedge clk);
		
		$stop;															
	end
	
endmodule

