module shiftlne #(parameter n = 8) 
                 (R, L, E, w, Clock, Q);
	input logic [n-1:0] R;
	input logic L, E, w, Clock;
	output logic [n-1:0] Q;
	integer k;

	always @(posedge Clock) begin
		if (L)
			Q <= R;
		else if (E)
			begin
			// fixed code, changed k = 0 and ends loop on k < n - 1;
				for (k = 0; k < n - 1; k++) 
					Q[k + 1] <= Q[k]; // added the increment with in the loop.
					Q[0] <= w; // now sets the lowest bit of zero to go to w input coming from the Cout.
			end
	end	
endmodule

