module line_drawer(clk, reset, x0, x1, y0, y1, x, y);
	input logic clk, reset;
	
	// x and y coordinates for the start and end points of the line
	input logic [10:0]	x0, x1; 
	input logic [10:0] y0, y1;

	//outputs cooresponding to the coordinate pair (x, y)
	output logic [10:0] x;
	output logic [10:0] y;
	
	
	logic [10:0] dx, dxVal, xfirst, xlast;
	logic [10:0] dy, dyVal, yfirst, ylast;
	logic signed [11:0] error, errorVal, errorNext, errorTemp;
	logic [10:0] xVal, xNext;
	logic [10:0] yVal, yNext, ystep;
	logic steep;
	
	always_comb begin
		dxVal = (x1 > x0) ? (x1 - x0) : (x0 - x1);
		dyVal = (y1 > y0) ? (y1 - y0) : (y0 - y1);
		steep = (dyVal > dxVal);
		
		xfirst = (~steep & (x0>x1)) ? x1 : (~steep & ~(x0>x1)) ? x0 : (steep & (y0>y1)) ? y1: y0;
		
		xlast = (~steep & (x0>x1)) ? x0: (~steep & ~(x0>x1)) ? x1: (steep & (y0>y1)) ? y0: y1;
		
		yfirst = (~steep & (x0>x1)) ? y1: (~steep & ~(x0>x1)) ? y0: (steep & (y0>y1)) ? x1: x0;
		
		ylast = (~steep & (x0>x1)) ? y0: (~steep & ~(x0>x1)) ? y1: (steep & (y0>y1)) ? x0: x1;
		
		dx = steep ? dyVal : dxVal;
		dy = steep ? dxVal : dyVal;
		
		errorTemp = -(dx/2);
		
		ystep = (yfirst < ylast) ? 1: -1;
		
		xNext = xVal + 1'b1;
		errorVal = error + dy;
		yNext = (errorVal >= 0) ? yVal + ystep: yVal;
		errorNext = (errorVal >= 0) ? errorVal - dx: errorVal;
		
		y = steep ? xVal : yVal;
		x = steep ? yVal : xVal;
		
	end
	
	always_ff @(posedge clk)
		begin
			if (reset)
				begin
					xVal <= xfirst;
					yVal <= yfirst;
					error <= errorTemp;
				end
			else
			begin
					if (((xlast == xVal) || (ylast == yVal)))					
						begin
							xVal <= xVal;
							yVal <= yVal;
							error <= error;
						end
					else 
						begin
							xVal <= xNext;
							yVal <= yNext;
							error <= errorNext;
						end
				end
		end			
	
endmodule

module line_drawer_testbench();
	logic clk, reset;
	
	// x and y coordinates for the start and end points of the line
	logic [9:0]	x0, x1; 
	logic [8:0] y0, y1;

	//outputs cooresponding to the coordinate pair (x, y)
	logic [10:0] x;
	logic [10:0] y;
	
	line_drawer dut(.clk, .reset, .x0, .x1, .y0, .y1, .x, .y);
	
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	
	initial begin
		x0 <= 10'd10; x1 <= 10'd600;
	   y0 <= 9'd400; y1 <= 9'd10;
	   reset <= 1;                                   @(posedge clk);
	   reset <= 0;                                   @(posedge clk);                           	

		repeat(20)                                     @(posedge clk);
		
		$stop;															
	end
	
endmodule

