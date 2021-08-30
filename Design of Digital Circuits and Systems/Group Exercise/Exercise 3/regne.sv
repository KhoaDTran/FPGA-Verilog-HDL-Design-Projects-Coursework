module regne #(parameter n = 8)
				  (R, Clock, Resetn, E, Q);
	input logic [n-1:0] R;
	input logic Clock, Resetn, E;
	output logic [n-1:0] Q;

	always @(posedge Clock) begin
		if (Resetn)
			Q <= 0;
		else if (E)
			Q <= R;	
	end

endmodule

