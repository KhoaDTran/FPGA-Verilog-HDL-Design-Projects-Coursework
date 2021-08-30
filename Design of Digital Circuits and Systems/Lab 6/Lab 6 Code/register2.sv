//Khoa Tran and Ravi Sangani
//05/22/2020
//Lab 5, Task 2
//Module register2 outputs 0 on reset and the input of D on enable (en).
//The output is on variable Q and using sequential DFF, Q output is 
//on each posedge clk
module register2(clk, reset, en, D, Q);
	input logic clk, reset, en;
	input logic [23:0] D;
	output logic [23:0] Q;
	
	always_ff @(posedge clk)
		begin
			if (reset)
				Q <= 0;
			else if (en)
				Q <= D;
		end
endmodule

//Module register is a testbench to see if the outputs on
//the register module of Q is correct along the posedge
//clk with a series of inputs on reset, en, and D
module register2_testbench();
	logic clk, reset, en;
	logic [23:0] D;
	logic [23:0] Q;
	
	register2 dut(.clk, .reset, .en, .D, .Q);
	
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	
		initial begin
		reset <= 1; en <= 0; D <= 23'd50; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd50; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd50; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd50; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd50; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd50; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd50; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd50; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd50; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd50; @(posedge clk);
		reset <= 1; en <= 0; D <= 23'd50; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd60; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd40; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd60; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd40; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd60; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd40; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd60; @(posedge clk);
		reset <= 0; en <= 1; D <= 23'd40; @(posedge clk);
		$stop;
	end
endmodule
