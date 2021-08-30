//Group 4
//EE 371
//04/23/2021
//Group Exercise 2, Number 5
//Module sync_rom is a read only memory that reads binary
//inputs from signMagAdd_65536x8.txt, and reading from an
//read address input, outputting to output data
module sync_rom2(clk, addr, data);
	input logic clk;
	input logic [15:0] addr;
	output logic [7:0] data;
	
	logic [7:0] rom [0:65535];
	logic [7:0] data_reg;
	
	initial
		$readmemb("C:/Users/tynou/Dropbox/College/Junior/Spring/EE 371/Lab/lab0 - Copy/signMagAdd_65536x8.txt", rom);
	
	//sequential logic, reading from rom
	always_ff @(posedge clk)
		data_reg <= rom[addr];
	assign data = data_reg;
endmodule

//Module is test bench for sync_rom2 size 65536x8 testing for outputs on
//data through a series of inputs on addr at each clock edge
module sync_rom2_testbench();
	logic clk;
	logic [15:0] addr;
	logic [7:0] data;
	
	//devices under test
	sync_rom2 dut (.clk, .addr, .data);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	//initial simulation
	initial begin
		addr <= 16'b0000000000000000;				@(posedge clk);
		#10;
		addr <= 16'b0000000000000001;				@(posedge clk);
		#10;
		addr <= 16'b0000000000000010;				@(posedge clk);
		#10;
		addr <= 16'b0000000000000011;				@(posedge clk);
		#10;
		addr <= 16'b0000000000000100;				@(posedge clk);
		#10;
		addr <= 16'b0000000000000101;				@(posedge clk);
		#10;
		addr <= 16'b0000000000000110;				@(posedge clk);
		#10;
		addr <= 16'b0000000000000111;				@(posedge clk);
		#10;
		addr <= 16'b0000000000001000;				@(posedge clk);
		#10;
		addr <= 16'b0000000000001001;				@(posedge clk);
		#10;
		addr <= 16'b0000000000001010;				@(posedge clk);
		#10;
		addr <= 16'b0000000000001011;				@(posedge clk);
		#10;
		addr <= 16'b0000000000001100;				@(posedge clk);
		#10;
		$stop; //end simulation
	end
endmodule
	
	