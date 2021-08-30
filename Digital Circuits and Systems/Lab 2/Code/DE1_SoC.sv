//Khoa Tran
//07/10/2020
//Lab 2
//This module uses the UPC module in order to execute a 4-bit number input that determines
//the item and if it is discounted or stolen. If discounted, the LED0 will turn on, and if it is stolen
//LED1 will turn on. The switches 6-8 is the UPC code and the switch 0 is the Mark to determine if an item
//was previously purchased from the store. Additionally, the HEX 7 segment will display the name of the item

//Implementing the UPC and nseg7 with 4 different 1-bit binary number as inputs. The SW[0] represent a one-bit value 
//called the Mark, while the SW[6-8] represents a 1-bit binary number that combines to determine an item.
//The LEDR0 outputs for the Discounted item and LEDR1 outputs if the item was stolen. Finally, the 7 segment HEX will be 
//determined through the type of item and the UPC code associated with through instanitating the nseg7 module.
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	logic u;
	logic p;
	logic c;
	logic m;
	logic discounted;
	logic stolen;
	logic upcSW;
	
	assign u = SW[8];
	assign p = SW[7];
	assign c = SW[6];
	assign m = SW[0];
		
	assign LEDR[1] = stolen;
	assign LEDR[0] = discounted;
	
	UPC UP (.U(u), .P(p), .C(c), .M(m), .Discounted(discounted), .Stolen(stolen));
	
	//seg7 inst_1(.bcd(upcSW), .leds(HEX0));
	//assign HEX2 = 7'b1111111;
	//assign HEX3 = 7'b1111111;
	//assign HEX4 = 7'b1111111;
	//assign HEX5 = 7'b1111111;
	assign HEX1 = 7'b1111111;
	
	nseg7 inst_2 (.bcd(SW[8:6]), .leds1(HEX0), .leds2(HEX5), .leds3(HEX4), .leds4(HEX3), .leds5(HEX2));
	
endmodule

//Test the DE1_SoC by a truth table that consist of a total
//of 16 combinations as a binary count from 0 to 15 represented by 
//the SW[6-8] and SW[0] for the inputs
module DE1_SoC_testbench();

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);

	integer i;
	initial begin
	SW[9] = 1'b0;
	SW[5] = 1'b0;
	SW[4] = 1'b0;
	SW[3] = 1'b0;
	SW[2] = 1'b0;
	SW[1] = 1'b0;
	for (i=0; i<2**4; i++) begin
		SW[8:6] = i; #10;
		SW[0] = i; #10;
	end
end

endmodule
