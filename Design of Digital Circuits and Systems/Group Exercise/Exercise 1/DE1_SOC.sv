
// Full adder module, (combinational only logic)
module fullAdder(A, B, cin, sum, cout);
	input logic A,B,cin;
	output logic sum,cout;
	
	assign sum = A ^ B ^ cin;
	assign cout = A&B | cin & (A^B);
endmodule 

// D flip flop module (sequential only logic)
module D_Flip_Flop(clk, reset, D, Q);
	input logic clk, reset, D;
	output logic Q;
	
	always_ff @(posedge clk) begin 
		if (reset) Q <= 1'b0;
		else Q <= D;
	end
endmodule 

// Top level module (takes input x, y)
module DE1_SOC(X, Y, clk, S, reset);
	input logic X, Y, clk, reset;
	logic Q, C;
	output logic S;
	
	// Full adder is connected to the D flip flop as specified in the question
	fullAdder FA (.A(X), .B(Y), .cin(Q), .sum(S), .cout(C));
	D_Flip_Flop FL (.clk(clk), .reset(reset), .D(C), .Q(Q));
endmodule

module DE1_SOC_testbench();
	logic X, Y, S, clk, reset;				
	
	DE1_SOC dut (.X, .Y, .clk, .S, .reset);
	
	// clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		X <= 0;
		Y <= 0;
		reset <= 0;
		forever #(clock_period / 2) clk <= ~clk;
	end // initial
	
	
	initial begin 
		reset <=1;	@(posedge clk);
						@(posedge clk);
		reset <=0;  @(posedge clk);
						@(posedge clk);
						@(posedge clk);
		X <= 1; 		@(posedge clk);
						@(posedge clk);
		Y <= 1;		@(posedge clk);
						@(posedge clk);
		X <= 0; Y <=1; @(posedge clk);
							@(posedge clk);
							@(posedge clk);
							
		X<= 1;		@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);

		$stop;
	end // initial
endmodule







