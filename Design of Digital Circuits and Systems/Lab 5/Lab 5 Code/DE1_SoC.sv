//Khoa Tran and Ravi Sangani
//05/22/2020
//Lab 5, Task 1
//Module DE1_SoC uses an audio coder/decoder in order to recieve audio inputs
//and record it, outputting the given input sound. This DE1_SoC module has KEY3 as the
//reset, KEY0 as the input for task 1, KEY1 as the input for task 2, and KEY2 as the input
//for task 3. In task 1, noise is added into the sound of the input audio, and in task 2
//a fir filter is implemented in order to reduce the noise by averaging 8 consecutive samples
//and for task 3, the parameterized version of fir filter allows for averaging n samples
//and reduce the noise even further or less based on the n value.
module DE1_SoC #(parameter n = 16)(CLOCK_50, CLOCK2_50, FPGA_I2C_SCLK, FPGA_I2C_SDAT,
	AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT,
	KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);

	input logic CLOCK_50, CLOCK2_50;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	// Local wires
	logic read_ready, write_ready, read, write;
	logic signed [23:0] readdata_left, readdata_right;
	logic signed [23:0] writedata_left, writedata_right;
	logic signed [23:0] task2_left, task2_right, task3_left, task3_right;
	logic signed [23:0] noisy_left, noisy_right;
	logic reset;
	
	logic [23:0] noise, filtered1Left, filtered1Right, filtered2Left, filtered2Right;
	noise_gen noise_generator (.clk(CLOCK_50), .en(read), .rst(reset), .out(noise));
	assign noisy_left = readdata_left + noise;
	assign noisy_right = readdata_right + noise;
	
	//instatiation of firFilter for both noisy_left and noisy_right as inputs to data and result on task2_left and task2_right
	firFilter filterL(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered1Left));
	firFilter filterR(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered1Right));
	assign task2_left = filtered1Left;
	assign task2_right = filtered1Right;
	
	//instatiation of nFirFilter with n as 16 for both noisy_left and noisy_right as inputs to data and result on task3_left and task3_right
	nFirFilter filter2L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered2Left));
		defparam filter2L.n = n;
	nFirFilter filter2R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered2Right));
		defparam filter2R.n = n;
	assign task3_left = filtered2Left;
	assign task3_right = filtered2Right;
	
	//combinational logic for KEY to see which key calls which task
	always_comb begin
		case(KEY[2:0])
			3'b110: begin // KEY0 outputs noise
				writedata_left = noisy_left;
				writedata_right = noisy_right;
			end
			3'b101: begin // KEY1 outputs task2 filtered noise
				writedata_left = task2_left;
				writedata_right = task2_right;
			end
			3'b011: begin // KEY2 outputs task3 filtered noise
				writedata_left = task3_left;
				writedata_right = task3_right;
			end
			default: begin // default output raw data
				writedata_left = readdata_left;
				writedata_right = readdata_right;
			end
		endcase
	end
	
	assign reset = ~KEY[3];
	assign {HEX0, HEX1, HEX2, HEX3, HEX4, HEX5} = '1;
	assign LEDR = SW;
	
	// only read or write when both are possible
	assign read = read_ready & write_ready;
	assign write = read_ready & write_ready;
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		1'b0,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		1'b0,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		1'b0,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule
