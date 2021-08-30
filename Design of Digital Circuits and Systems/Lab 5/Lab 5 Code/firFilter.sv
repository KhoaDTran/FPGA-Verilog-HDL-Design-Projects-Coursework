//Khoa Tran and Ravi Sangani
//05/22/2020
//Lab 5, Task 1
//Module firFilter represents a fir Filter for 8 samples of inputs
//averaging them in order to filter out the noise created. 
//The fir filter uses a series of shift registers to shift the inputs, divide
//and combine to output to the result
module firFilter(clk, rst, en, data, result);
	input logic clk, rst, en;
	input logic [23:0] data;
	output logic [23:0] result;
	
	logic [23:0] temp1, temp2, temp3, temp4, temp5, temp6, temp7;
	logic [23:0] combine1, combine2, combine3, combine4, combine5, combine6;
	
	//instatiation of register modules presenting a series of shift registers
	register r1(.clk, .reset(rst), .en, .D(data), .Q(temp1));
	register r2(.clk, .reset(rst), .en, .D(temp1), .Q(temp2));
	register r3(.clk, .reset(rst), .en, .D(temp2), .Q(temp3));
	register r4(.clk, .reset(rst), .en, .D(temp3), .Q(temp4));
	register r5(.clk, .reset(rst), .en, .D(temp4), .Q(temp5));
	register r6(.clk, .reset(rst), .en, .D(temp5), .Q(temp6));
	register r7(.clk, .reset(rst), .en, .D(temp6), .Q(temp7));
	
	//divide each registers' output and add them together
	assign combine1 = (({{3{data[23]}}, data[23:3]}) + ({{3{temp1[23]}}, temp1[23:3]}) + ({{3{temp2[23]}}, temp2[23:3]}) + ({{3{temp3[23]}}, temp3[23:3]}) + ({{3{temp4[23]}}, temp4[23:3]}) + ({{3{temp5[23]}}, temp5[23:3]}) + ({{3{temp6[23]}}, temp6[23:3]}));
	//output result as combination of all
	assign result = ((combine1) + ({{3{temp7[23]}}, temp7[23:3]}));

endmodule

//Module firFilter represents a fir Filter for 8 samples of inputs
//averaging them in order to filter out the noise created. 
//The fir filter uses a series of shift registers to shift the inputs, divide
//and combine to output to the result
module firFilter_testbench();
	logic clk, rst, en;
	logic [23:0] data;
	logic [23:0] result;
	
	//device under test
	firFilter dut(.clk, .rst, .en, .data, .result);
	
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
		$stop;
	end
endmodule
