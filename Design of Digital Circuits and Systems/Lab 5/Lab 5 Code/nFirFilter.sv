//Khoa Tran and Ravi Sangani
//05/22/2020
//Lab 5, Task 2
//Module nFirFilter parameterize the firFilter module by allowing inputs of
//n size for the number of samples to average and combine. In this module, 
//to parameterize the firFilter, generate allows for a for loop, calling
//register2 module n-1 times and storing the output on a 2D array, that has
//n locations and storing a 24 bit value given from the register
module nFirFilter#(parameter n=16)(clk, rst, en, data, result);
	input logic clk, rst, en;
	input logic [23:0] data;
	output logic [23:0] result;
	
	
	logic [23:0] resultTemp;
	logic [n-1:0][23:0] temp;
	logic [23:0] dividedData;
	logic signed [23:0] last;
	logic [23:0] accumulator, addTemp;
	
	//divide input data by n
	assign dividedData = {{$clog2(n){data[23]}}, data[23:$clog2(n)]};
	
	//generate statement
	genvar i;
	generate
		//for loop from 0 to n-1
		for (i = 0; i <= n - 1; i = i+1) begin: generate_shift_registers
			//at first index, store dividedData into the first index of 2D temp array
			if (i == 0)
				register2 rN(.clk, .reset(rst), .en, .D(dividedData), .Q(temp[0][23:0]));
			//otherwise shift the values of the index
			else
				register2 r1(.clk, .reset(rst), .en, .D(temp[i-1][23:0]), .Q(temp[i][23:0]));
		end
	endgenerate
	
	//get the last value in 2d temp array
	assign last = temp[n-1][23:0];
	//get dividedData - last to keep the average for n samples
	assign resultTemp = dividedData - last;
	
	//sequential DFF for accumulator getting resultTemp + previous accumulator value on posedge clk
	always_ff @(posedge clk) begin
		if (rst)
			accumulator <= 0;
		else if (en)
			accumulator <= addTemp;
	end
	
	assign addTemp = resultTemp + accumulator;
	//output the result which is the total of accumulator plus resultTemp
	assign result = addTemp;
	
endmodule

//Testbench for nFirFilter, parameterizing firFilter
//giving n = 16, and a series of inputs on data and en, 
//seeing if the output on result is correct along
//posedge clk
module nFirFilter_testbench#(parameter n = 16)();
	logic clk, rst, en;
	logic [23:0] data;
	logic [23:0] result;
	
	//device under test
	nFirFilter dut(.clk, .rst, .en, .data, .result);
		defparam dut.n = n;
	
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	
	//initial simulation
	initial begin
		rst <= 1; en <= 0; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd50; @(posedge clk);
		rst <= 1; en <= 0; data <= 23'd50; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd60; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd40; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd60; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd40; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd60; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd40; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd60; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd40; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd60; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd40; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd60; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd40; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd60; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd40; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd60; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd40; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd60; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd40; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd60; @(posedge clk);
		rst <= 0; en <= 1; data <= 23'd40; @(posedge clk);
		$stop;
	end
endmodule
