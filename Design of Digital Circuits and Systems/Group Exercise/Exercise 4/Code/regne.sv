//Group 4
//Group Excerise 4
//05/18/2021
//register module setting Q to 0 on reset, and Q to R on E signal
module regne (R, Clock, Resetn, E, Q);
	parameter n = 8;
	input logic [n-1:0] R;
	input logic Clock, Resetn, E;
	output logic [n-1:0] Q;

	always_ff @(posedge Clock, negedge Resetn)
		if (Resetn == 0)
			Q <= 0;
		else if (E)
			Q <= R;

endmodule

