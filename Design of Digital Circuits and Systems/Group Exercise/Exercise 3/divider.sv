module divider #(parameter n = 8, logn = 3) 
                (Clock, Resetn, s, LA, EB, DataA, DataB, R, Q, Done);
	input logic Clock, Resetn, s, LA, EB;
	input logic [n-1:0] DataA, DataB;
	output logic [n-1:0] R, Q;
	output logic Done;
	logic Cout, z;
	logic [n-1:0] DataR;
	logic [n:0] Sum;
	logic [1:0] y, Y;
	logic [n-1:0] A, B;
	logic [logn-1:0] Count;
	logic EA, Rsel, LR, ER, ER0, LC, EC, R0;
	integer k;

// control circuit

	parameter S1 = 2'b00, S2 = 2'b01, S3 = 2'b10;

	always_comb 
	begin
		// defaults
		LR = 0; ER = 0; ER0 = 0; LC = 0; EC = 0; EA = 0;
		Rsel = 0; Done = 0;
		case (y)
			S1:	
	      begin
				LC = 1; ER = 1;
				LR = ~s;
				ER0 = s;
				EA = s;
				if (s == 0) 
					Y = S1;
				else Y = S2;
			end
			S2:	
			begin
				Rsel = 1; ER = 1; ER0 = 1; EA = 1;
				LR = Cout;
				EC = ~z;
				if (z == 0) 
					Y = S2;
				else Y = S3;
			end
			S3: 
			begin
			Done = 1;
				if (s == 1)
					Y = S3;
				else Y = S1;
			end
			default: Y = 2'bxx;
		endcase
	end

	always_ff @(posedge Clock)
	begin
		if (Resetn)
			y <= S1;
		else
			y <= Y;
	end

//datapath circuit

	regne #(n) RegB (.R(DataB), .Clock, .Resetn, .E(EB), .Q(B));
	
	shiftlne #(n) ShiftR (.R(DataR), .L(LR), .E(ER), .w(R0), .Clock, .Q(R));
	
	muxdff FF_R0 (.D0(1'b0), .D1(A[n-1]), .Sel(ER0), .Clock, .Q(R0));
	
	shiftlne #(n) ShiftA (.R(DataA), .L(LA), .E(EA), .w(Cout), .Clock, .Q(A));

	assign Q = A;
	downcount #(n) Counter (.R(8'b00000111), .Clock, .E(EC), .L(LC), .Q(Count));

	assign z = (Count == 0);
	assign Sum = {1'b0, R[n-2:0], R0} + {1'b0, ~B} + 1'b1;
	assign Cout = Sum[n];
	
	// define the n 2-to-1 multiplexers
	assign DataR = Rsel ? Sum : 7'b0;

endmodule

module divider_testbench();
	parameter n = 8, logn = 3;
	logic Clock, Resetn, s, LA, EB;
	logic [n-1:0] DataA, DataB;
	logic [n-1:0] R, Q;
	logic Done;

		// using Verilog's positional port connections.	
	divider dut(.*);
	
	parameter Clock_PERIOD=50;
	initial begin
		Clock <= 0;
		forever #(Clock_PERIOD/2) Clock <= ~Clock;
	end //initial
	
initial begin
		LA <= 1'b0; EB <= 1'b0; s <= 1'b0;                          @(posedge Clock);
		Resetn <= 1'b0;                                        @(posedge Clock);
		Resetn <= 1'b1;                                        @(posedge Clock);
		Resetn <= 1'b0;                                        @(posedge Clock);
		// 128 / 32 = 4Q R0 (big/small) exact
		DataA = 8'b10000000; DataB = 8'b00010000; LA <= 1'b1; EB <= 1'b1;          @(posedge Clock);
		s <= 1'b1;
		repeat(20)                                          @(posedge Clock);
		s <= 1'b0; LA <= 1'b0; EB <= 1'b0;
		
		// 152 / 150 = 1Q R2 " " not exact
		DataA = 8'b10011000; DataB = 8'b10000110; LA <= 1'b1; EB <= 1'b1;          @(posedge Clock);		
		s <= 1'b1;
		repeat(20)                                          @(posedge Clock);
		s <= 1'b0; LA <= 1'b0; EB <= 1'b0;
		
		// 10 / 37 = 0Q R10  (small / big) not exact
		DataA = 8'b00001010; DataB = 8'b00100101;  LA <= 1'b1; EB <= 1'b1;          @(posedge Clock);				
		s <= 1'b1;
		repeat(20)                                          @(posedge Clock);
		s <= 1'b0; LA <= 1'b0; EB <= 1'b0;
		
		// 19 / 7 = 2Q R5   (big / small) odd remainder
		DataA = 8'b00010011; DataB = 8'b00000111;  LA <= 1'b1; EB <= 1'b1;          @(posedge Clock);		 		
		s <= 1'b1;
		repeat(20)                                          @(posedge Clock);
		s <= 1'b0; LA <= 1'b0; EB <= 1'b0;                                      @(posedge Clock);	

		// 255 / 1 = 255Q R0  minimum divisor
		DataA = 8'b11111111; DataB = 8'b00000001;  LA <= 1'b1; EB <= 1'b1;          @(posedge Clock);				
		s <= 1'b1;
		repeat(20)                                          @(posedge Clock);
		s <= 1'b0; LA <= 1'b0; EB <= 1'b0;                                       @(posedge Clock);	
		

		// 1 / 255 = 0Q R1   maximum divisor
		DataA = 8'b00000001; DataB = 8'b11111111;	 LA <= 1'b1; EB <= 1'b1;          @(posedge Clock);			
		s <= 1'b1;
		repeat(20)                                          @(posedge Clock);
		s <= 1'b0; LA <= 1'b0; EB <= 1'b0;                        @(posedge Clock);	
		
		// 0 / 64 = 0Q R0    0 case
		DataA = 8'b00000000; DataB = 8'b01000000;  LA <= 1'b1; EB <= 1'b1;          @(posedge Clock);		
		s <= 1'b1;
		repeat(20)                                          @(posedge Clock);
		s <= 1'b0; LA <= 1'b0; EB <= 1'b0;                                      @(posedge Clock);	


		// 64 / 0 = error    error case 
		DataA = 8'b01000000; DataB = 8'b00000000;	 LA <= 1'b1; EB <= 1'b1;          @(posedge Clock);		
		s <= 1'b1;
		repeat(20)                                          @(posedge Clock);
		s <= 1'b0; LA <= 1'b0; EB <= 1'b0;                                  @(posedge Clock);	


		// 0 / 0 = error     error case
		DataA = 8'b00000000; DataB = 8'b00000000;	 LA <= 1'b1; EB <= 1'b1;          @(posedge Clock);		
		s <= 1'b1;
		repeat(20)                                          @(posedge Clock);
		s <= 1'b0; LA <= 1'b0; EB <= 1'b0;                                      @(posedge Clock);	

																			 @(posedge Clock);
											           			  	    @(posedge Clock);

		$stop;
	end //inital
	
endmodule

