//Group 4
//EE 371
//04/23/2021
//Group Exercise 2, Number 5
//Module sync_rom is a read only memory that reads binary
//inputs from signMagAdd_256x4.txt, and reading from an
//read address input, outputting to output data
module sync_rom(clk, addr, data);
	input logic clk;
	input logic [7:0] addr;
	output logic [3:0] data;
	
	logic [3:0] rom [0:255];
	logic [3:0] data_reg;
	
	initial
		$readmemb("C:/Users/tynou/Dropbox/College/Junior/Spring/EE 371/Lab/lab0 - Copy/signMagAdd_256x4.txt", rom);
	
	//sequential logic, reading from rom
	always_ff @(posedge clk)
		data_reg <= rom[addr];
	assign data = data_reg;
endmodule

//Module is test bench for sync_rom testing for outputs on
//data through a series of inputs on addr at each clock edge
module sync_rom_testbench();
	logic clk;
	logic [7:0] addr;
	logic [3:0] data;
	
	//devices under test
	sync_rom dut (.clk, .addr, .data);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	//initial simulation
	initial begin
		addr <= 8'b00000000;				@(posedge clk);
		#10;
		addr <= 8'b00000001;				@(posedge clk);
		#10;
		addr <= 8'b00000010;				@(posedge clk);
		#10;
		addr <= 8'b00000011;				@(posedge clk);
		#10;
		addr <= 8'b00000100;				@(posedge clk);
		#10;
		addr <= 8'b00000101;				@(posedge clk);
		#10;
		addr <= 8'b00000110;				@(posedge clk);
		#10;
		addr <= 8'b00000111;				@(posedge clk);
		#10;
		addr <= 8'b00001000;				@(posedge clk);
		#10;
		addr <= 8'b00001001;				@(posedge clk);
		#10;
		addr <= 8'b00001010;				@(posedge clk);
		#10;
		addr <= 8'b00001011;				@(posedge clk);
		#10;
		addr <= 8'b00001100;				@(posedge clk);
		#10;
		$stop; //end simulation
	end
endmodule
	
	