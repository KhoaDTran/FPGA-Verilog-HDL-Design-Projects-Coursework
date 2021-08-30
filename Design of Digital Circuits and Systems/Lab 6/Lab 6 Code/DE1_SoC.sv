//Khoa Tran and Ravi Sangani
//06/07/2020
//Lab 6, Task 1
//Module DE1_SoC uses drivers from audio_codec, n8 controller, and video driver for an audio visualizer
//on the VGA display. This audio visualizer can visualize audio with noise, or noise with a desired
//number of firFilter to minimize the noise, or the original audio itself. Using inputs of SW[1],
//the audio will be the original sound plus the noise. SW[0] will reset back to visualize the original
//audio and finally, KEY[1] and KEY[0] are used for up and down inputs for the user to decide on the 
//number of firFilter to use to filter out the noise. The amount of firFilter goes from 1-31, in order to
//see the differences between a large number of filters and a small number of filters. Overall,
//this module can visualize a series of different audios to compare sound, filtering, and originality.  
module DE1_SoC #(parameter n = 16)(CLOCK_50, CLOCK2_50, FPGA_I2C_SCLK, FPGA_I2C_SDAT, KEY, SW,
	AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT, 
	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR,
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);

	//input and output wires
	input logic CLOCK_50, CLOCK2_50;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	
	// Video output
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	
	logic startTemp, a, b;
	
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	//count wire
	logic [4:0] countTemp;
	
	// Local wires
	logic read_ready, write_ready, read, write;
	logic signed [23:0] readdata_left, readdata_right;
	logic signed [23:0] writedata_left, writedata_right;
	logic signed [23:0] task2_left, task2_right, task3_left, task3_right;
	logic signed [23:0] left1, left2, left3, left4, left5, left6, left7, left8, left9, left10, left11, left12, left13, left14, left15, left16, left17, left18, left19, left20, left21, left22, left23, left24, left25, left26, left27, left28;
	logic signed [23:0] right1, right2, right3, right4, right5, right6, right7, right8, right9, right10, right11, right12, right13, right14, right15, right16, right17, right18, right19, right20, right21, right22, right23, right24, right25, right26, right27, right28;
	logic signed [23:0] noisy_left, noisy_right;
	logic reset;
	logic [23:0] noise, filtered1Left, filtered1Right, filtered2Left, filtered2Right;
	logic [23:0] filtered3Left, filtered3Right, filtered4Left, filtered4Right, filtered5Left, filtered5Right, filtered6Left, filtered6Right, filtered8Left, filtered8Right, filtered9Left, filtered9Right, filtered10Left, filtered10Right;
	logic [23:0] filtered11Left, filtered11Right, filtered12Left, filtered12Right, filtered13Left, filtered13Right, filtered14Left, filtered14Right, filtered15Left, filtered15Right, filtered16Left, filtered16Right;
	logic [23:0] filtered17Left, filtered17Right, filtered18Left, filtered18Right, filtered19Left, filtered19Right, filtered20Left, filtered20Right, filtered21Left, filtered21Right, filtered22Left, filtered22Right;
	logic [23:0] filtered23Left, filtered23Right, filtered24Left, filtered24Right, filtered25Left, filtered25Right, filtered26Left, filtered26Right, filtered27Left, filtered27Right, filtered28Left, filtered28Right,  filtered29Left, filtered29Right;
	logic [23:0]  filtered30Left, filtered30Right,  filtered31Left, filtered31Right;
	
	//instatiation of noise_gen to generate noise into readdata_left and readdata_right
	noise_gen noise_generator (.clk(CLOCK_50), .en(read), .rst(reset), .out(noise));
	assign noisy_left = readdata_left + noise;
	assign noisy_right = readdata_right + noise;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 2
	nFirFilter filter1L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered1Left));
		defparam filter1L.n = 2;
	nFirFilter filter1R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered1Right));
		defparam filter1R.n = 2;
	assign left1 = filtered1Left;
	assign right1 = filtered1Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 3
	nFirFilter filter2L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered2Left));
		defparam filter2L.n = 3;
	nFirFilter filter2R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered2Right));
		defparam filter2R.n = 3;
	assign left2 = filtered2Left;
	assign right2 = filtered2Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 4
	nFirFilter filter3L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered3Left));
		defparam filter3L.n = 4;
	nFirFilter filter3R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered3Right));
		defparam filter3R.n = 4;
	assign left3 = filtered3Left;
	assign right3 = filtered3Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 5
	nFirFilter filter4L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered4Left));
		defparam filter4L.n = 5;
	nFirFilter filter4R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered4Right));
		defparam filter4R.n = 5;
	assign left4 = filtered4Left;
	assign right4 = filtered4Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 6
	nFirFilter filter5L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered5Left));
		defparam filter5L.n = 6;
	nFirFilter filter5R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered5Right));
		defparam filter5R.n = 6;
	assign left5 = filtered5Left;
	assign right5 = filtered5Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 7
	nFirFilter filter6L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered6Left));
		defparam filter6L.n = 7;
	nFirFilter filter6R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered6Right));
		defparam filter6R.n = 7;
	assign left6 = filtered6Left;
	assign right6 = filtered6Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 8
	nFirFilter filter8L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered8Left));
		defparam filter8L.n = 8;
	nFirFilter filter8R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered8Right));
		defparam filter8R.n = 8;
	assign task2_left = filtered8Left;
	assign task2_right = filtered8Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 9
	nFirFilter filter9L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered9Left));
		defparam filter9L.n = 9;
	nFirFilter filter9R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered9Right));
		defparam filter9R.n = 9;
	assign left7 = filtered9Left;
	assign right7 = filtered9Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 10
	nFirFilter filter10L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered10Left));
		defparam filter10L.n = 10;
	nFirFilter filter10R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered10Right));
		defparam filter10R.n = 10;
	assign left8 = filtered10Left;
	assign right8 = filtered10Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 11
	nFirFilter filter11L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered11Left));
		defparam filter11L.n = 11;
	nFirFilter filter11R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered11Right));
		defparam filter11R.n = 11;
	assign left9 = filtered11Left;
	assign right9 = filtered11Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 12
	nFirFilter filter12L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered12Left));
		defparam filter12L.n = 12;
	nFirFilter filter12R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered12Right));
		defparam filter12R.n = 12;
	assign left10 = filtered12Left;
	assign right10 = filtered12Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 13
	nFirFilter filter13L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered13Left));
		defparam filter13L.n = 13;
	nFirFilter filter13R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered13Right));
		defparam filter13R.n = 13;
	assign left11 = filtered13Left;
	assign right11 = filtered13Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 14
	nFirFilter filter14L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered14Left));
		defparam filter14L.n = 14;
	nFirFilter filter14R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered14Right));
		defparam filter14R.n = 14;
	assign left12 = filtered14Left;
	assign right12 = filtered14Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 15
	nFirFilter filter15L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered15Left));
		defparam filter15L.n = 15;
	nFirFilter filter15R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered15Right));
		defparam filter15R.n = 15;
	assign left13 = filtered15Left;
	assign right13 = filtered15Right;
	
	//instatiation of nFirFilter with n as 16 for both noisy_left and noisy_right as inputs to data and result on task3_left and task3_right
	nFirFilter filter16L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered16Left));
		defparam filter16L.n = 16;
	nFirFilter filter16R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered16Right));
		defparam filter16R.n = 16;
	assign task3_left = filtered16Left;
	assign task3_right = filtered16Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 17
	nFirFilter filter17L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered17Left));
		defparam filter17L.n = 17;
	nFirFilter filter17R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered17Right));
		defparam filter17R.n = 17;
	assign left14 = filtered17Left;
	assign right14 = filtered17Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 18
	nFirFilter filter18L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered18Left));
		defparam filter18L.n = 18;
	nFirFilter filter18R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered18Right));
		defparam filter18R.n = 18;
	assign left15 = filtered18Left;
	assign right15 = filtered18Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 19
	nFirFilter filter19L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered19Left));
		defparam filter19L.n = 19;
	nFirFilter filter19R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered19Right));
		defparam filter19R.n = 19;
	assign left16 = filtered19Left;
	assign right16 = filtered19Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 20
	nFirFilter filter20L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered20Left));
		defparam filter20L.n = 20;
	nFirFilter filter20R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered20Right));
		defparam filter20R.n = 20;
	assign left17 = filtered20Left;
	assign right17 = filtered20Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 21
	nFirFilter filter21L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered21Left));
		defparam filter21L.n = 21;
	nFirFilter filter21R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered21Right));
		defparam filter21R.n = 21;
	assign left18 = filtered21Left;
	assign right18 = filtered21Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 22
	nFirFilter filter22L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered22Left));
		defparam filter22L.n = 22;
	nFirFilter filter22R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered22Right));
		defparam filter22R.n = 22;
	assign left19 = filtered22Left;
	assign right19 = filtered22Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 23
	nFirFilter filter23L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered23Left));
		defparam filter23L.n = 23;
	nFirFilter filter23R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered23Right));
		defparam filter23R.n = 23;
	assign left20 = filtered23Left;
	assign right20 = filtered23Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 24
	nFirFilter filter24L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered24Left));
		defparam filter24L.n = 24;
	nFirFilter filter24R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered24Right));
		defparam filter24R.n = 24;
	assign left21 = filtered24Left;
	assign right21 = filtered24Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 25
	nFirFilter filter25L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered25Left));
		defparam filter25L.n = 25;
	nFirFilter filter25R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered25Right));
		defparam filter25R.n = 25;
	assign left22 = filtered25Left;
	assign right22 = filtered25Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 26
	nFirFilter filter26L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered26Left));
		defparam filter26L.n = 26;
	nFirFilter filter26R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered26Right));
		defparam filter26R.n = 26;
	assign left23 = filtered26Left;
	assign right23 = filtered26Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 27
	nFirFilter filter27L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered27Left));
		defparam filter27L.n = 27;
	nFirFilter filter27R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered27Right));
		defparam filter27R.n = 27;
	assign left24 = filtered27Left;
	assign right24 = filtered27Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 28
	nFirFilter filter28L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered28Left));
		defparam filter28L.n = 28;
	nFirFilter filter28R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered28Right));
		defparam filter28R.n = 28;
	assign left25 = filtered28Left;
	assign right25 = filtered28Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 29
	nFirFilter filter29L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered29Left));
		defparam filter29L.n = 29;
	nFirFilter filter29R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered29Right));
		defparam filter29R.n = 29;
	assign left26 = filtered29Left;
	assign right26 = filtered29Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 30
	nFirFilter filter30L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered30Left));
		defparam filter30L.n = 30;
	nFirFilter filter30R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered30Right));
		defparam filter30R.n = 30;
	assign left27 = filtered30Left;
	assign right27 = filtered30Right;
	
	//instatiation of nFirFilter for left and right channels with parameter n = 31
	nFirFilter filter31L(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_left), .result(filtered31Left));
		defparam filter31L.n = 31;
	nFirFilter filter31R(.clk(CLOCK_50), .rst(reset), .en(read), .data(noisy_right), .result(filtered31Right));
		defparam filter31R.n = 31;
	assign left28 = filtered31Left;
	assign right28 = filtered31Right;
	
	//combinational logic for SW[1] and countTemp from controlN to decide either
	//writing of original audio data, original audio and noise, or original audio
	//and noise filtered countTemp times.
	always_comb begin
		case({SW[1], countTemp})
			6'b00000: begin 
				writedata_left = readdata_left;
				writedata_right = readdata_right;
			end
			6'b00001: begin 
				writedata_left = readdata_left;
				writedata_right = readdata_right;
			end
			6'd2: begin 
				writedata_left = left1;
				writedata_right = right1;
			end
			6'd3: begin 
				writedata_left = left2;
				writedata_right = right2;
			end
			6'd4: begin 
				writedata_left = left3;
				writedata_right = right3;
			end
			6'd5: begin 
				writedata_left = left4;
				writedata_right = right4;
			end
			6'd6: begin
				writedata_left = left5;
				writedata_right = right5;
			end
			6'd7: begin 
				writedata_left = left6;
				writedata_right = right6;
			end
			6'd8: begin 
				writedata_left = task2_left;
				writedata_right = task2_right;
			end
			6'd9: begin 
				writedata_left = left7;
				writedata_right = right7;
			end
			6'd10: begin 
				writedata_left = left8;
				writedata_right = right8;
			end
			6'd11: begin 
				writedata_left = left9;
				writedata_right = right9;
			end
			6'd12: begin 
				writedata_left = left10;
				writedata_right = right10;
			end
			6'd13: begin 
				writedata_left = left11;
				writedata_right = right11;
			end
			6'd14: begin 
				writedata_left = left12;
				writedata_right = right12;
			end
			6'd15: begin 
				writedata_left = left13;
				writedata_right = right13;
			end
			6'd16: begin 
				writedata_left = task3_left;
				writedata_right = task3_right;
			end
			6'd17: begin 
				writedata_left = left14;
				writedata_right = right14;
			end
			6'd18: begin 
				writedata_left = left15;
				writedata_right = right15;
			end
			6'd19: begin 
				writedata_left = left16;
				writedata_right = right16;
			end
			6'd20: begin 
				writedata_left = left17;
				writedata_right = right17;
			end
			6'd21: begin 
				writedata_left = left18;
				writedata_right = right18;
			end
			6'd22: begin 
				writedata_left = left19;
				writedata_right = right19;
			end
			6'd23: begin 
				writedata_left = left20;
				writedata_right = right20;
			end
			6'd24: begin 
				writedata_left = left21;
				writedata_right = right21;
			end
			6'd25: begin 
				writedata_left = left22;
				writedata_right = right22;
			end
			6'd26: begin 
				writedata_left = left23;
				writedata_right = right23;
			end
			6'd27: begin 
				writedata_left = left24;
				writedata_right = right24;
			end
			6'd28: begin 
				writedata_left = left25;
				writedata_right = right25;
			end
			6'd29: begin 
				writedata_left = left26;
				writedata_right = right26;
			end
			6'd30: begin 
				writedata_left = left27;
				writedata_right = right27;
			end
			6'd31: begin 
				writedata_left = left28;
				writedata_right = right28;
			end
			default: begin // default output noisy data
				writedata_left = noisy_left;
				writedata_right = noisy_right;
			end
		endcase
	end
	
	//reset to KEY[3]
	assign reset = ~KEY[3];
	
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
	
	//N8 driver
    n8_driver driver(
        .clk(CLOCK_50),
        .data_in(N8_DATA_IN),
        .latch(N8_LATCH),
        .pulse(N8_PULSE),
        .up(),
        .down(),
        .left(),
        .right(),
        .select(),
        .start(startTemp),
        .a(a),
        .b(b)
    );
    
	//local wires
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, bColor;
	logic [6:0] hex1Temp, hex0Temp;
	
	//video_driver of VGA 640x480, outputing x and y and inputs rgb for color at the coordinate outputted
	video_driver #(.WIDTH(640), .HEIGHT(480))
		v1 (.CLOCK_50, .reset(1'b0), .x, .y, .r, .g, .b(bColor),
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
	
	//instatiation of audioControl, using audio data chosen, and x and y coordinate from video driver, output rgb based on the values of
	//left and right channels in 16 rectanges with varying width and height based on audio input
	audioControl audio1(.clk(CLOCK_50), .rst(reset), .en(read), .dataL(writedata_left), .dataR(writedata_right), .x, .y, .r, .g, .b(bColor));
	
	//instatiation of controlN allowing SW[0] to reset the count back to 0 and KEY1 and KEY0 to increment count that is displayed on HEX1 and HEX0
	controlN nVal(.clk(CLOCK_50), .start(SW[0]), .up(~KEY[1]), .down(~KEY[0]), .count(countTemp), .hex1(HEX1), .hex0(HEX0));
	
	//make HEX2-5 blank
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	

endmodule

