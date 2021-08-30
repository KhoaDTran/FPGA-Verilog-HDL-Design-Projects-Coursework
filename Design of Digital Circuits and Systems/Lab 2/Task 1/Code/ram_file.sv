//Khoa Tran
//04/22/2021
//Lab 2, Task 1
//This module is a ram file implemented as a 32x4 size ram, with inputs of clk, wr_sig as the
//write signal, in_data as the input data, and out_data as the output data.
//On the posedge clock, with wr_sig, the ram will write the given data to the given address
//in the ram. The output data will always read from the given address.
module ram_file #(parameter data_width = 4, addr_width = 5) (clk, wr_sig, in_data, addr, out_data);
	input logic clk;
	input logic wr_sig;
	input logic [data_width - 1:0] in_data;
	input logic [addr_width - 1:0] addr;
	output logic [data_width - 1:0] out_data;
	
	//ram logic
	logic [data_width -1:0] memory_array [0:2**addr_width - 1];
	
	//sequential logic, writting data to the given address when wr_sig is true
	always_ff @(posedge clk)
		begin
			if (wr_sig)
				memory_array[addr] <= in_data;
		end
	//output data is the data at the given address in the ram
	assign out_data = memory_array[addr];
endmodule

//This module is a testbench for the ram_file, testing for inputs
//in_data, wr_sig, and addr provides the correct output of the out_data
//at the posedge clk.
module ram_file_testbench#(parameter data_width = 4, addr_width = 5)();
	logic clk, wr_sig;
	logic [data_width - 1:0] in_data, out_data;
	logic [addr_width - 1:0] addr;
	
	//device under test
	ram_file dut(.clk, .wr_sig, .in_data, .addr, .out_data);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	//initial simulation
	initial begin
		in_data<=4'b0000; wr_sig<=1'b0;	addr<=5'b00000;	@(posedge clk);
		in_data<=4'b0001; wr_sig<=1'b1;	addr<=5'b00000;	@(posedge clk);
		#10;
		in_data<=4'b0010; wr_sig<=1'b0;	addr<=5'b00001;	@(posedge clk);	
		in_data<=4'b0011; wr_sig<=1'b1;	addr<=5'b00001;	@(posedge clk);
		#10;
		in_data<=4'b0011; wr_sig<=1'b0;	addr<=5'b00010;	@(posedge clk);	
		in_data<=4'b0100; wr_sig<=1'b1;	addr<=5'b00011;	@(posedge clk);
		#10;
		in_data<=4'b0101; wr_sig<=1'b0;	addr<=5'b00100;	@(posedge clk);
		in_data<=4'b0110; wr_sig<=1'b1;	addr<=5'b00101;	@(posedge clk);
		#10;
		$stop; //end simulation
	end
endmodule
