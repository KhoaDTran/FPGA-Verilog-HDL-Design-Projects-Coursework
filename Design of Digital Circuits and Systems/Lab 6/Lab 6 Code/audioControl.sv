//Khoa Tran and Ravi Sangani
//06/07/2020
//Lab 6, Task 1

//This module takes in clock, reset, and enable, which are 1 bit in size.
//It also has inputs dataL and dataR, which are 24 bits in size, and are the two-channel
//audio sample values. This module also takes in x and y, which are 10 bits and 9 bits
//in size respectively, representing the current coordinate. The outputs are r, g, and b,
//which are 8 bits in size, representing the color to be outputted based on current x and y.
//Overall, this module enables the creation of 16 adjacent rectangles whose heights, widths,
//and colors are based on the input audio sample. For one incoming two-channel audio sample,
//we manipulate two rectangles side by side, the left rectangle for left audio and right rectangle
//for right audio. We use 16 registers to shift the incoming audio samples through by storing
//the samples and then passing into the next register on each clock cycle. This means that all
//the even numbered rectangles are storing 16 consecutive right audio samples,
//and all the odd numbered rectangles are storing 16 consecutive left audio samples. 

module audioControl(clk, rst, en, dataL, dataR, x, y, r, g, b);
	input logic clk, rst, en;
	input logic [23:0] dataL, dataR;
	input logic [9:0] x;
	input logic [8:0] y;
	output logic [7:0] r, g, b;
	
	logic [23:0] tempL1, tempL2, tempL3, tempL4, tempL5, tempL6, tempL7;
	logic [23:0] tempR1, tempR2, tempR3, tempR4, tempR5, tempR6, tempR7;
	
	//instatiation of register modules presenting a series of shift registers
	register rL1(.clk, .reset(rst), .en, .D(dataL), .Q(tempL1));
	register rL2(.clk, .reset(rst), .en, .D(tempL1), .Q(tempL2));
	register rL3(.clk, .reset(rst), .en, .D(tempL2), .Q(tempL3));
	register rL4(.clk, .reset(rst), .en, .D(tempL3), .Q(tempL4));
	register rL5(.clk, .reset(rst), .en, .D(tempL4), .Q(tempL5));
	register rL6(.clk, .reset(rst), .en, .D(tempL5), .Q(tempL6));
	register rL7(.clk, .reset(rst), .en, .D(tempL6), .Q(tempL7));
	
	register rR1(.clk, .reset(rst), .en, .D(dataR), .Q(tempR1));
	register rR2(.clk, .reset(rst), .en, .D(tempR1), .Q(tempR2));
	register rR3(.clk, .reset(rst), .en, .D(tempR2), .Q(tempR3));
	register rR4(.clk, .reset(rst), .en, .D(tempR3), .Q(tempR4));
	register rR5(.clk, .reset(rst), .en, .D(tempR4), .Q(tempR5));
	register rR6(.clk, .reset(rst), .en, .D(tempR5), .Q(tempR6));
	register rR7(.clk, .reset(rst), .en, .D(tempR6), .Q(tempR7));
	
	logic [9:0] checker1, checker2, checker3, checker4, checker5, checker6, checker7, checker8, checker9, checker10, checker11, checker12, checker13, checker14, checker15, checker16;
	
	//Each checker value is the summation of the previous checker value and the value represented by the first five digits
	//of the audio sample in the current corresponding register. 
	assign checker1 = dataL[4:0];
	assign checker2 = checker1 + dataR[4:0];
	assign checker3 = checker2 + tempL1[4:0];
	assign checker4 = checker3 + tempR1[4:0];
	assign checker5 = checker4 + tempL2[4:0];
	assign checker6 = checker5 + tempR2[4:0];
	assign checker7 = checker6 + tempL3[4:0];
	assign checker8 = checker7 + tempR3[4:0];
	assign checker9 = checker8 + tempL4[4:0];
	assign checker10 = checker9 + tempR4[4:0];
	assign checker11 = checker10 + tempL5[4:0];
	assign checker12 = checker11 + tempR5[4:0];
	assign checker13 = checker12 + tempL6[4:0];
	assign checker14 = checker13 + tempR6[4:0];
	assign checker15 = checker14 + tempL7[4:0];
	assign checker16 = checker15 + tempR7[4:0];
	
	//This always_ff block handles the logic of figuring out the respective r, g, b values based on
	//the dataL and dataR. The above "checkers" are used in manipulating the widths of each rectangle
	//by only displaying the calculated RGB color if the input x is equal to or past the checker threshold.
	//The height is manipulated by only displaying the calculated RGB value if the input y is greater than
	//or equal to the value represented by taking the middle 6 digits of audio sample in current corresponding register.
	//For the 16 audio samples, left audio values are red dominant and right audio values are blue dominant. The
	//proportion of green is determined by looking at the value represented by the last three digits of
	//corresponding audio sample. This is also what would change if any noise is added. 
	always_ff @(posedge clk) begin
		if (rst) begin
			r <= 8'd0;
			g <= 8'd0;
			b <= 8'd0;
			end
		else begin
			if ((x < checker1) && (y >= dataL[12:5])) begin
				r <= dataL[20:13];
				g <= {dataL[23:21], 5'b00000};
				b <= 8'd0;
				end
			else if ((x >= checker1) && (x < checker2) && (y >= dataR[13:8]))
				begin
					r <= 8'd0;
					g <= {dataR[23:21], 5'b00000};
					b <= dataR[20:13];
				end
			else if ((x >= checker2) && (x < checker3) && (y >= tempL1[13:8]))
				begin
					r <= tempL1[20:13];
					g <= {tempL1[23:21], 5'b00000};
					b <= 8'd0;
				end
			else if ((x >= checker3) && (x < checker4) && (y >= tempR1[13:8]))
				begin
					r <= 8'd0;
					g <= {tempR1[23:21], 5'b00000};
					b <= tempR1[20:13];
				end
			else if ((x >= checker4) && (x < checker5) && (y >= tempL2[13:8]))
				begin
					r <= tempL2[20:13];
					g <= {tempL2[23:21], 5'b00000};
					b <= 8'd0;
				end
			else if ((x >= checker5) && (x < checker6) && (y >= tempR2[13:8]))
				begin
					r <= 8'd0;
					g <= {tempR2[23:21], 5'b00000};
					b <= tempR2[20:13];
				end
			else if ((x >= checker6) && (x < checker7) && (y >= tempL3[13:8]))
				begin
					r <= tempL3[20:13];
					g <= {tempL3[23:21], 5'b00000};
					b <= 8'd0;
				end
			else if ((x >= checker7) && (x < checker8) && (y >= tempR3[13:8]))
				begin
					r <= 8'd0;
					g <= {tempR3[23:21], 5'b00000};
					b <= tempR3[20:13];
				end
			else if ((x >= checker8 ) && (x < checker9) && (y >= tempL4[13:8]))
				begin
					r <= tempL4[20:13];
					g <= {tempL4[23:21], 5'b00000};
					b <= 8'd0;
				end
			else if ((x >= checker9) && (x < checker10) && (y >= tempR4[13:8]))
				begin
					r <= 8'd0;
					g <= {tempR4[23:21], 5'b00000};
					b <= tempR4[20:13];
				end
			else if ((x >= checker10) && (x < checker11) && (y >= tempL5[13:8]))
				begin
					r <= tempL5[20:13];
					g <= {tempL5[23:21], 5'b00000};
					b <= 8'd0;
				end
			else if ((x >= checker11) && (x < checker12) && (y >= tempR5[13:8]))
				begin
					r <= 8'd0;
					g <= {tempR5[23:21], 5'b00000};
					b <= tempR5[20:13];
				end
			else if ((x >= checker12) && (x < checker13) && (y >= tempL6[13:8]))
				begin
					r <= tempL6[20:13];
					g <= {tempL6[23:21], 5'b00000};
					b <= 8'd0;
				end
			else if ((x >= checker13) && (x < checker14) && (y >= tempR6[13:8]))
				begin
					r <= 8'd0;
					g <= {tempR6[23:21], 5'b00000};
					b <= tempR6[20:13];
				end
			else if ((x >= checker14) && (x < checker15) && (y >= tempL7[13:8]))
				begin
					r <= tempL7[20:13];
					g <= {tempL7[23:21], 5'b00000};
					b <= 8'd0;
				end
			else if ((x >= checker15) && (x < checker16) && (y >= tempR7[13:8]))
				begin
					r <= 8'd0;
					g <= {tempR7[23:21], 5'b00000};
					b <= tempR7[20:13];
				end
			else 
				begin
					r <= 8'd0;
					g <= 8'd0;
					b <= 8'd0;
				end
			end
		end
	
endmodule

//This testbench ensures full functionality of the above module. In specific, we test
//arbitrary two-channel audio values and input x and y, to make sure that the registers work as expected,
//the rectangles are manipulated properly in height, width, and color, and that reset works. 
module audioControl_testbench();
	logic clk, rst, en;
	logic [23:0] dataL, dataR;
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	
	audioControl dut(.clk, .rst, .en, .dataL, .dataR, .x, .y, .r, .g, .b);
	
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	
	initial begin
		rst<=1; en <=0; dataL<=24'd500; dataR<=24'd600; x<=10'd200; y<=9'd50; @(posedge clk);
		rst<=0; en <=1; dataL<=24'd8800; dataR<=24'd8800; x<=10'd50; y<=9'd100; @(posedge clk);
		rst<=0; en <=1; dataL<=24'd8800; dataR<=24'd8800; x<=10'd30; y<=9'd100; @(posedge clk);
		rst<=0; en <=1; dataL<=24'd2000; dataR<=24'd3800; x<=10'd500; y<=9'd250; @(posedge clk);
		rst<=0; en <=1; dataL<=24'd2500; dataR<=24'd4800; x<=10'd400; y<=9'd350; @(posedge clk);
		rst<=0; en <=1; dataL<=24'd5000; dataR<=24'd5800; x<=10'd300; y<=9'd50; @(posedge clk);
		rst<=0; en <=1; dataL<=24'd6000; dataR<=24'd6800; x<=10'd200; y<=9'd70; @(posedge clk);
		rst<=0; en <=1; dataL<=24'd7000; dataR<=24'd7800; x<=10'd100; y<=9'd150; @(posedge clk);
		rst<=0; en <=1; dataL<=24'd5500; dataR<=24'd8800; x<=10'd150; y<=9'd130; @(posedge clk);
		rst<=0; en <=1; dataL<=24'd6000; dataR<=24'd9800; x<=10'd250; y<=9'd120; @(posedge clk);
		rst<=0; en <=1; dataL<=24'd700; dataR<=24'd8900; x<=10'd100; y<=9'd140; @(posedge clk);
		rst<=0; en <=1; dataL<=24'd300; dataR<=24'd9800; x<=10'd500; y<=9'd400; @(posedge clk);
		$stop;
	end
endmodule

		
	
	