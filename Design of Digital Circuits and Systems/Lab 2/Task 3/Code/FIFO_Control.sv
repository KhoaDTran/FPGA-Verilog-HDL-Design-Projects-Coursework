//Khoa Tran
//04/22/2021
//Lab 2, Task 3
//This module implements a FIFO controller that takes inpuit clk, reset, read, and write, outputting
//either if the state of the ram is full or empty based on outputs empty and full and also outputing 
//the write address and the read address that maintains the state of first in first out data, as data is read by
//the order that is entered in. As well as ensuring that write address goes in a queue.
module FIFO_Control#(parameter addr_width = 4)(clk, reset, read, write, wr_en, empty, full, readAddr, writeAddr);
	input logic clk, reset;
	input logic read, write;
	output logic wr_en;
	output logic empty, full;
	output logic [addr_width-1:0] readAddr, writeAddr;
	
	//logic variables for ptr and nextptr for both read and write, as well
	//as the result for empty and full
	logic [addr_width-1:0] writePtr, nextWritePtr;
	logic [addr_width-1:0] readPtr, nextReadPtr;
	logic emptyResult, fullResult;
	
	//assign output of readAddr and writeAddr to the readPtr and writePtr
	assign readAddr = readPtr;
	assign writeAddr = writePtr;
	
	//assign output of wr_en to write and read or write and not full
	assign wr_en = write & (read | ~full);
	
	//sequential logic with reset input setting writePtr, readPtr, full, and empty
	//as well well as setting writePtr, readPtr, full, and empty to the next and result of
	//their perspective value on a posedge clk
	always_ff @(posedge clk) 
		begin
			if (reset) 
				begin
					writePtr <= 0;
					readPtr <= 0;
					full <= 0;
					empty <= 1;
				end
			else
				begin
					writePtr <= nextWritePtr;
					readPtr <= nextReadPtr;
					full <= fullResult;
					empty <= emptyResult;
				end
		end
	
	//combinational logic 
	always_comb 
		begin
			//setting the next and result variables to the current, default values
			fullResult = full;
			emptyResult = empty;
			nextWritePtr = writePtr;
			nextReadPtr = readPtr;
			case ({write, read})
				//case of write and not read, if not full then make emptyResult false,
				//increment nextWritePtr and set fullResult to true on the condition below
				2'b10:
					if (~full)
						begin
							emptyResult = 0;
							nextWritePtr = writePtr + 1;
							if (nextWritePtr == readPtr)
								fullResult = 1;
						end
				//case of read and not write, if not empty then increment nextReadPtr
				//and set full to false as well as well as empty to true on condition below
				2'b01:
					if (~empty)
						begin
							nextReadPtr = readPtr + 1;
							fullResult = 0;
							if (nextReadPtr == writePtr)
								emptyResult = 1;
						end
				//case of read and write, if not full, then increment write pointer, asserting 
				//full on condition below, as well as if not empty then increment nextReadPtr
				2'b11:
					begin
						if (~full)
							begin
								nextWritePtr = writePtr + 1;
								if (nextWritePtr == readPtr)
									fullResult = 1;
							end
						if (~empty)
							begin
								nextReadPtr = readPtr + 1;
							end
					end
				//case of no read and no write, set empty on given condition, otherwise, do nothing
				2'b00: 
					if (~full & (writePtr == readPtr))
						begin
							emptyResult = 1;
						end
			endcase
		end
endmodule

//Module is testbench for FIFO_Control by a series of values on reset, clk, read, and write to
//test if the outputs of wr_en, empty, full, readAddr, and writeAddr is correct alont each
//posedge clk
module FIFO_Control_testbench#(parameter addr_width = 4)();
	logic clk, reset;
	logic read, write;
	logic wr_en;
	logic empty, full;
	logic [addr_width-1:0] readAddr, writeAddr;
	
	//device under test
	FIFO_Control dut(.clk, .reset, .read, .write, .wr_en, .empty, .full, .readAddr, .writeAddr);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	//initial simulation
	initial begin
		reset <= 1;				@(posedge clk);
		reset <= 0; read <= 0;	write <= 0;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 1;	write <= 0;		@(posedge clk);
		reset <= 0; read <= 1;	write <= 0;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 0;		@(posedge clk);
		reset <= 0; read <= 1;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 1;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 0;	write <= 1;		@(posedge clk);
		reset <= 0; read <= 1;	write <= 0;		@(posedge clk);
		reset <= 0; read <= 1;	write <= 0;		@(posedge clk);

		$stop; //end simulation
	end
endmodule
