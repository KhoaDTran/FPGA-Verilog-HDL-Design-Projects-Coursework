module downcount #(parameter n = 8)
						(R, Clock, E, L, Q);
	input logic [n-1:0] R;
	input logic Clock, L, E;
	output logic [n-1:0] Q;

	always_ff @(posedge Clock) begin
		if (L)
			Q <= R;
		else if (E) begin
			if(Q > 0) // checks whether the output Q is still greater 
				Q <= Q - 1;
			else // otherwise, Q is still the same
				Q <= Q;
		end

	end

endmodule
