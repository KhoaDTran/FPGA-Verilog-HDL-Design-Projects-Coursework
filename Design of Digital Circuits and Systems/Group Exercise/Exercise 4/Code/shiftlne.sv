//Group 4
//Group Excerise 4
//05/18/2021
//Shiftline module shifts Q to the left on E signal and index 0 set as W
module shiftlne (R, L, E, w, Clock, Q);
	parameter n = 8;
	input logic [n-1:0] R;
	input logic L, E, w, Clock;
	output logic [n-1:0] Q;
	integer k;

	always_ff @(posedge Clock)
	begin
		if (L)
			Q <= R;
		else if (E)
			begin
				//changed this part
				Q <= Q << 1;
				Q[0] <= w;
			end
	end

endmodule


