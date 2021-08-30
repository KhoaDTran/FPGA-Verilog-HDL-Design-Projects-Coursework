//Group 4
//Group Excerise 4
//05/18/2021
//mux module, based on Sel, Output either D0, or D1
module muxdff (D0, D1, Sel, Clock, Q);
	input logic D0, D1, Sel, Clock;
	output logic Q;

	always_ff @(posedge Clock)
	 	if (~Sel)
			Q <= D0;
		else 
			Q <= D1;
		
endmodule

