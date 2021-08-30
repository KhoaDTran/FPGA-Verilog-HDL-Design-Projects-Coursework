module muxdff (D0, D1, Sel, Clock, Q);
	input logic D0, D1, Sel, Clock;
	output logic  Q;

	always @(posedge Clock) begin
	 	if (~Sel)
			Q <= D0;
		else 
			Q <= D1;
	end
		
endmodule

