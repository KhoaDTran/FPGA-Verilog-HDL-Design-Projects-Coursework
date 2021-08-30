//Group 4
//Group Excerise 4
//05/18/2021
//downcount subtracts R by 1 on E signal
module downcount (R, Clock, E, L, Q);
	parameter n = 3;
	input logic [n-1:0] R;
	input logic Clock, L, E;
	output logic [n-1:0] Q;

	always_ff @(posedge Clock) begin
		if (L)
			Q <= R;
		else if (E) begin
			//added this checker to ensure
			if (Q > 0)
				Q<= Q - 1;
			else 
				Q <= Q;
		end
	end
endmodule
