//Khoa Tran and Ravi Sangani
//05/14/2020
//Lab 4, Task 1
//Module bitcounter implements a finite state machine that outputs a series
//of different outputs based on present state and input conditions in order
//for the datapath to manipulate data at the correct states. In this module
//inputs of clk, reset, data, and Z controls the state logic as the outputs
//of LA, LB, EA, EB, and Done is for loading and enabling outputs for the inputs in the
//datapath as Done is for indicating the program is done counting the number of
//1 bit in a 8-bit binary input. Present state progresses to next state at posedge clk
//and reset starts the present state at S0.
module bitcounter(clk, reset, data, start, Z, LA, LB, EA, EB, Done);
	input logic clk, reset, start, Z;
	input logic [7:0] data;
	output logic LA, LB, EA, EB, Done;
	
	//present and next state declaration
	enum {S0, S1, S2} ps, ns;
	
	//combinational logic going through different cases of present state
	always_comb begin
		case(ps)
			S0: begin
					//if start then progress to next state otherwise stay at S0
					if (start) ns = S1;
					else ns = S0;
				end
			S1: begin 
					//if input Z is 0, stay at S1 otherwise progress to S2
					if (Z == 0) ns = S1;
					else ns = S2;
				end
			S2: begin
					//if start then progress to next state otherwise stay at S2
					if (start) ns = S2;
					else ns = S0;
				end
		endcase
	end
	
	//sequential logic DFFs for the value of present state
	always_ff @(posedge clk) begin
		if (reset) 
			ps <= S0;
		else 
			ps <= ns;
	end
	
	//output load B
	assign LB = (ps == S0);
	//output enable A
	assign EA = (ps == S1);
	//output Done
	assign Done = (ps == S2);
	//output enable B
	assign EB = (ps == S1 && data[0] == 1);
	//output load A
	assign LA = (ps == S0 && start == 0);
endmodule

//module bitcounter_testbench is a testbench for bitcounter
//setting a series of inputs on reset, start, data, and Z, in order
//to test the progression of the present state and the outputs of
//LB, LA, EB, EA, and Done at the posedge clk.
module bitcounter_testbench();
	logic clk, reset, start, Z;
	logic [7:0] data;
	logic LA, LB, EA, EB, Done;
	
	//device under test
	bitcounter count(.clk, .reset, .data, .start, .Z, .LA, .LB, .EA, .EB, .Done);
	
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	
	//initial simulation
	initial begin
		reset <= 1; start<=0; data<=8'd5; Z <= 0; @(posedge clk);
		reset <= 0; start<=1; data<=8'd5; Z <= 0; @(posedge clk);
		reset <= 0; start<=1; data<=8'd5; Z <= 0; @(posedge clk);
		reset <= 0; start<=1; data<=8'd5; Z <= 0; @(posedge clk);
		reset <= 0; start<=1; data<=8'd5; Z <= 1; @(posedge clk);
		reset <= 0; start<=0; data<=8'd5; Z <= 1; @(posedge clk);
		reset <= 0; start<=0; data<=8'd5; Z <= 0; @(posedge clk);
		reset <= 1; start<=0; data<=8'd5; Z <= 0; @(posedge clk);
		reset <= 0; start<=1; data<=8'd10; Z <= 1; @(posedge clk);
		reset <= 0; start<=1; data<=8'd10; Z <= 1; @(posedge clk);
		reset <= 0; start<=0; data<=8'd10; Z <= 1; @(posedge clk);
		
		$stop;
		
	end
endmodule

	
