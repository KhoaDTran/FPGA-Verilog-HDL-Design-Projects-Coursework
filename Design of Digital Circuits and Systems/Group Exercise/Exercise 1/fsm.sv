module fsm (clk, reset, in, out);
	input logic clk, reset, in; //input for clk, reset, an a bit input
	output logic out; //output bit
	
	enum {S0, S1, S2, S3, S4} ps, ns; //all five states, present state, next state
	
	always_comb begin //comb next state logic
		case (ps)
			S0: if (in) ns = S4;
					 else ns = S2;
			S1: if (in) ns = S4;
					 else ns = S1;
			S2: if (in) ns = S3;
					 else ns = S1;
			S3: if (in) ns = S0;
					 else ns = S3;
			S4: if (in) ns = S3;
					 else ns = S3;
		endcase
	end
	
	// equation for output as it depends on present state and input, in.
	assign out = (((ps == S0) & in) | ((ps == S1) & in) | ((ps == S2) & in) | ((ps == S3) & in));
		
		//sequential logic (DFFS)
		always_ff @(posedge clk) begin
			if (reset)
				ps <= S0;
			else
				ps <= ns;
		end
endmodule

module fsm_testbench();

	logic clk, reset, in, out;
	
	//devices under test
	fsm dut (.clk, .reset, .in, .out);
	
	//clock setup
	parameter clock_period = 100;
	
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	//initial simulation
	initial begin
		reset <= 1;						@(posedge clk);
		reset <= 0; in<=0;			@(posedge clk);
		reset <= 0; in<=0;			@(posedge clk);
		reset <= 0; in<=0;			@(posedge clk);
		reset <= 0; in<=0;			@(posedge clk);
		reset <= 0; in<=0;			@(posedge clk);
		reset <= 0; in<=0;			@(posedge clk);
		reset <= 0; in<=0;			@(posedge clk);
		reset <= 0; in<=1;			@(posedge clk);
		reset <= 0; in<=1;			@(posedge clk);
		reset <= 0; in<=1;			@(posedge clk);
		reset <= 0; in<=1;			@(posedge clk);
		reset <= 0; in<=1;			@(posedge clk);
		reset <= 0; in<=1;			@(posedge clk);
		reset <= 0; in<=1;			@(posedge clk);
		reset <= 0; in<=1;			@(posedge clk);
		
		$stop; //end simulation
	end
endmodule
		