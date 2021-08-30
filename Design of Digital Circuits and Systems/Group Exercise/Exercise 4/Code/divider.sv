//Group 4
//Group Excerise 4
//05/18/2021
//Module divider outputs the remainder and value of dividing A by B
module divider(Clock, Resetn, s, LA, EB, DataA, DataB, R, Q, Done);
	parameter n = 8, logn = 3;
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
	begin: State_table
		case (y)
			S1:	if (s == 0) Y = S1;
				else Y = S2;
			S2:	if (z == 0) Y = S2;
				else Y = S3;
			S3:	if (s == 1) Y = S3;
				else Y = S1;
			default: Y = 2'bxx;
		endcase
	end

	always_ff @(posedge Clock) //took out negedge
	begin: State_flipflops
		if (Resetn == 0)
			y <= S1;
		else
			y <= Y;
	end
	
	always_comb 
	begin: FSM_outputs
		// defaults
		LR = 0; ER = 0; ER0 = 0; LC = 0; EC = 0; EA = 0;
		Rsel = 0; Done = 0;
		case (y)
			S1:	begin
					LC = 1; ER = 1;
					if (s == 0)
						begin
							LR = 1; ER0 = 0;
						end
					else
						begin
							LR = 0; EA = 1; ER0 = 1;
						end
				end
			S2:	begin
					Rsel = 1; ER = 1; ER0 = 1; EA = 1;
					if (Cout == 1) LR = 1;
					else LR = 0;
					if (z == 0) EC = 1;
					else EC = 0;
				end
			S3:	Done = 1;
		endcase
	end

//datapath circuit

	regne regB (.R(DataB), .Clock, .Resetn, .E(EB), .Q(B));
		defparam regB.n = n;
	shiftlne ShiftR (.R(DataR), .L(LR), .E(ER), .w(R0), .Clock, .Q(R));
		defparam ShiftR.n = n;
	muxdff FF_R0 (.D0(1'b0), .D1(A[n-1]), .Sel(ER0), .Clock, .Q(R0));
	
	shiftlne ShiftA (.R(DataA), .L(LA), .E(EA), .w(Cout), .Clock, .Q(A));
		defparam ShiftA.n = n;
	assign Q = A;
	downcount Counter (.R(3'b111), .Clock, .E(EC), .L(LC), .Q(Count));
		defparam Counter.n = logn;

	assign z = (Count == 0);
	assign Sum = {1'b0, R[n-2:0], R0} + {1'b0, ~B} + 1;
	assign Cout = Sum[n];
	
	// define the n 2-to-1 multiplexers
	assign DataR = Rsel ? Sum : 0;

endmodule

//Testbench module test for output of divider 
module divider_testbench#(parameter n = 8, logn = 3)();
	logic Clock, Resetn, s, LA, EB;
	logic [n-1:0] DataA, DataB;
	
	logic [n-1:0] R, Q;
	logic Done;
	
	divider dut(.Clock, .Resetn, .s, .LA, .EB, .DataA, .DataB, .R, .Q, .Done);
	
	parameter clock_period = 100;
		
		initial begin
			Clock <= 0;
			forever #(clock_period /2) Clock <= ~Clock;
					
		end //initial
	
		initial begin
			Resetn <= 0; LA <= 0; EB <= 0; DataA <= 0; DataB <= 0; s <= 0; @(posedge Clock); 
			Resetn <= 1; LA <= 1; EB <= 1; DataA <= 30; DataB <= 6; s <= 0; @(posedge Clock); 
			Resetn <= 1; LA <= 0; EB <= 0; DataA <= 30; DataB <= 6; s <= 1; @(posedge Clock);
			Resetn <= 1; LA <= 0; EB <= 0; DataA <= 30; DataB <= 6; s <= 0; @(posedge Clock); 
			repeat(20) @(posedge Clock);
			
			Resetn <= 0; LA <= 0; EB <= 0; DataA <= 0; DataB <= 0; s <= 0; @(posedge Clock); 
			Resetn <= 1; LA <= 1; EB <= 1; DataA <= 120; DataB <= 16; s <= 0; @(posedge Clock); 
			Resetn <= 1; LA <= 0; EB <= 0; DataA <= 120; DataB <= 16; s <= 1; @(posedge Clock);
			Resetn <= 1; LA <= 0; EB <= 0; DataA <= 120; DataB <= 16; s <= 0; @(posedge Clock); 
			repeat(20) @(posedge Clock);
			
			Resetn <= 0; LA <= 0; EB <= 0; DataA <= 0; DataB <= 0; s <= 0; @(posedge Clock); 
			Resetn <= 1; LA <= 1; EB <= 1; DataA <= 50; DataB <= 6; s <= 0; @(posedge Clock); 
			Resetn <= 1; LA <= 0; EB <= 0; DataA <= 50; DataB <= 6; s <= 1; @(posedge Clock);
			Resetn <= 1; LA <= 0; EB <= 0; DataA <= 50; DataB <= 6; s <= 0; @(posedge Clock); 
			repeat(20) @(posedge Clock);
			
			$stop;
	end
	// end of simulation
	
	
endmodule 

	
