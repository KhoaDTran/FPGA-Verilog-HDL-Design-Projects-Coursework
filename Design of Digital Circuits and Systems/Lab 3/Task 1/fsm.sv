//Khoa Tran
//05/07/2021
//Lab 3, Task 2
//This module implements a fsm that manages outputs for the line_drawer as well as color
//for the VGA_framebuffer in order to animate a line going in a circle around the VGA 
//display. This controller moves through a series of states setting outputs of color and
//coordinates in order to display a line, clear it, and move the line and continue the process.
//On posedge clk, next state is loaded into present state and output values as well.
//This also output a resetOut that is a temporary reset for the line_drawer to start off on the 
//given coordinates
module fsm (check, clear, clk, reset, x0next, x1next, y0next, y1next, color, resetOut);
	input logic check;
	input logic clk, reset;
	output logic [9:0] x0next, x1next;
	output logic [9:0] y0next, y1next;
	output logic color;
	output logic resetOut;
	input logic clear;
	
 	logic [9:0] Ix0, Ix1, x0Temp, x1Temp;
 	logic [9:0] Iy0, Iy1, y0Temp, y1Temp;
	
	//states of S0, S1, S2, S3, and S4
	enum {S0, S1, S2, S3, S4} ps, ns;
	
	//assigning output of x0, y0, x1, y1 next values
	
	
	//counter logic
	logic [15:0] counter, counterVal, speed_counter;
	
	//combinational logic for going through states
	always_comb begin
		x0Temp = Ix0;
		x1Temp = Ix1;
		y0Temp = Iy0;
		y1Temp = Iy1;
		case (ps)
			S0: 
				//initial state, setting initial values
				begin
					x0Temp = 10'd10;
					x1Temp = 10'd500;
					y0Temp = 10'd10;
					y1Temp = 10'd400;
					color = 1;
					//conditions for moving onto the next state based on
					//if the line is done and counter, holding the state
					if (check && speed_counter >= 2000)
						ns = S1;
					else if (clear)
					    ns = S4;
					else
						ns = S0;
				end
			S1:
				begin
					//second state, clearing the previous line
					x0Temp = Ix0;
				 	x1Temp = Ix1;
				 	y0Temp = Iy0;
				 	y1Temp = Iy1;
					color = 0;
					//conditions for moving onto the next state based on
					//if the line is done and counter, holding the state
					if (check && speed_counter >= 2000)
						ns = S2;
					else if (clear)
						ns = S4;
					else
						ns = S1;
				end
			S2: 
				begin
					//conditions for incrementing x0Temp, x1Temp, y0Temp, y1Temp
					//based on current value and outputting color based on condition
				 	if (Iy0 < 409 && Iy1 > 11 && Ix0 == 10 && Ix1 == 510) begin 
				 		x0Temp = Ix0;
				 		x1Temp = Ix1;
				 		y0Temp = Iy0 + 50;
				 		y1Temp = Iy1 - 50;
				 		color = 1;
				 	end
				 	else if (Ix0 < 509 && Ix1 > 11 && Iy0 > 409 && Iy1 < 11) begin //(x0Temp < 509 && x1Temp > 11 && y0Temp > 409 && y1Temp < 11) begin
				 		x0Temp = Ix0 + 50;
				 		x1Temp = Ix1 - 50;
				 		y0Temp = Iy0;
				 		y1Temp = Iy1;
				 		color = 1;
				 	end
				 	else begin
				 		x0Temp = Ix0;
				 		x1Temp = Ix1;
				 		y0Temp = Iy0;
				 		y1Temp = Iy1;
				 		color = 0;
					end
					//conditions for moving onto the next state based on
					//if the line is done and counter, holding the state
					if (check && speed_counter >= 2000)
						ns = S3;
					else if (clear)
						ns = S4;
					else
						ns = S2;
				end
			S3: 
				begin
					//clearing previous line
					x0Temp = Ix0;
				 	x1Temp = Ix1;
				 	y0Temp = Iy0;
				 	y1Temp = Iy1;
					color = 0;
					//conditions for moving onto the next state based on
					//if the line is done and counter, holding the state
					if (check && speed_counter >= 2000)
						ns = S2;
					else 
						ns = S3;
				end
			S4:
			    begin
					//state of clearing the board
					x0Temp = Ix0;
				 	x1Temp = Ix1;
				 	y0Temp = Iy0;
				 	y1Temp = Iy1;
			      color = 0;
					//conditions for moving onto the next state based on
					//if the line is done and counter, holding the state
					if (clear)
						ns = S4;
					else 
						ns = S0;
				end
		endcase
		x0next = Ix0;
		x1next = Ix1;
		y0next = Iy0;
		y1next = Iy1;
		//outputs of resetOut for line_drawer reset
		resetOut = (counter == 0) ? 1: 0;
		//counter value based on if present state is equal to next state
		counterVal = (ns == ps) ? counter + 1: 0;
		
	end
	
	//sequential logic for incrementing speed_counter
	always_ff @(posedge clk) begin
		if (reset || resetOut) speed_counter <= 0;
		else speed_counter <= speed_counter + 1;
	end
	
	//sequential logic for setting present state based on reset or other
	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= S0;
			counter <= 0;
			end
		else
			begin
				ps <= ns;
				Ix0 <= x0Temp;
				Ix1 <= x1Temp;
				Iy0 <= y0Temp;
				Iy1 <= y1Temp;
				counter <= counterVal;
			end
		end
		
endmodule

//module testing the outputs of fsm and state transition by setting
//a series of inputs on reset and check, seeing if color, x0next, x1next,
//y0next, y1next, and resetOut is correct
module fsm_testbench();
	logic clk, reset;
	logic check;
	logic [9:0] x0next, x1next;
	logic [9:0] y0next, y1next;
	logic color;
	logic resetOut;
	
	//device under test
	fsm dut(.check, .clk, .reset, .x0next, .x1next, .y0next, .y1next, .color, .resetOut);
	
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	
	//initial
	initial begin
		reset = 1; @(posedge clk);
		reset = 0; check = 0; @(posedge clk);

		repeat(10)       @(posedge clk);
		
		check = 1; @(posedge clk);
		check = 0; @(posedge clk);
		check = 1; @(posedge clk);
		repeat(2000)       @(posedge clk);
		
	
		$stop;															
	end
	
endmodule

			