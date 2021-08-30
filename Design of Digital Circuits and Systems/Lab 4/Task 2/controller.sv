//Khoa Tran and Ravi Sangani
//05/14/2020
//Lab 4, Task 2
//Module controller implements an fsm that outputs load and enable logic based on inputs and
//present state in order for the datapath to manipulate lower and upper bounds of the ram
//memory in order to do a binary search for the given data input. Output Lfirst is for initial
//loading and Elower and Eupper is for enabling the change of either lower and upper, updating the
//values based on the condition of if data is larger or less than value when its not equal.
//Input start and reset is for starting the finite state machine as well as reseting to initial state.
//Present state progresses on posedge clk and outputs based on present state and comparing inputs values.
module controller(clk, reset, data, value, start, Lfirst, Found, Elower, Eupper, other);
	input logic clk, reset, start, other;
	input logic [7:0] data, value;
	output logic Lfirst, Found, Elower, Eupper;
	
	//present and next states
	enum {S0, S1, S2} ps, ns;
	
	//combinational logic of state progression
	always_comb begin
		case(ps)
			//initial state
			S0: begin
					if (start) ns = S1;
					else ns = S0;
				end
			//state of comparing value == data to either continue searching or progress to found state
			S1: begin 
					if ((value == data) && (~other)) ns = S2;
					else ns = S1;
				end
			//found state
			S2: begin
					if (start) ns = S2;
					else ns = S0;
				end
		endcase
	end
	
	
	//sequential logic of loading present state
	always_ff @(posedge clk) begin
		if (reset || other) 
			ps <= S0;
		else 
			ps <= ns;
	end
	
	//output of first state
	assign Lfirst = (ps == S0);
	
	//output of found state
	assign Found = (ps == S2);
	//output of Elower if at S1 and value < data
	assign Elower = (ps == S1) && (value != data) && (value < data);
	//output of Eupper if at S1 and value > data
	assign Eupper = (ps == S1) && (value != data) && (value > data);
endmodule

//module controller_testbench is a testbench for controller
//setting a series of inputs on reset, start, data, value, and other, in order
//to test the progression of the present state and the outputs of
//Lfirst, Eupper, Elower, and Found at the posedge clk.
module controller_testbench();
	logic clk, reset, start, other;
	logic [7:0] data, value;
	
	logic Lfirst, Found, Elower, Eupper;
	
	//device under test
	controller count(.clk, .reset, .data, .value, .start, .Lfirst, .Found, .Elower, .Eupper, .other);
	
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	
	//initial simulation
	initial begin
		reset <= 1; other<=0; data<=8'd5; value <= 8'd10; start<=0; @(posedge clk);
		reset <= 0; other<=0; data<=8'd5; value <= 8'd10; start<=0; @(posedge clk);
		reset <= 0; other<=0; data<=8'd5; value <= 8'd10; start<=1; @(posedge clk);
		reset <= 0; other<=0; data<=8'd8; value <= 8'd10; start<=1; @(posedge clk);
		reset <= 0; other<=0; data<=8'd10; value <= 8'd10; start<=1; @(posedge clk);
		reset <= 0; other<=0; data<=8'd10; value <= 8'd10; start<=0; @(posedge clk);
		reset <= 0; other<=0; data<=8'd24; value <= 8'd10; start<=1; @(posedge clk);
		reset <= 0; other<=1; data<=8'd24; value <= 8'd10; start<=0; @(posedge clk);
		reset <= 0; other<=0; data<=8'd15; value <= 8'd15; start<=1; @(posedge clk);
		reset <= 0; other<=0; data<=8'd15; value <= 8'd15; start<=0; @(posedge clk);
		$stop;
		
	end
endmodule
