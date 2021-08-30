module n8_display (
    input clk,
    input right, left, up, down, select, start, a, b,
    output reg[6:0] HEX0, 
    output reg[6:0] HEX1,
    output reg[6:0] HEX2,
    output reg[6:0] HEX3,
    output reg[6:0] HEX4,
    output reg[6:0] HEX5);

    always @(posedge clk) begin
        // Left hex (up/down)
        if (up == 1) begin
            // UP
            HEX5 = 7'b1000001;
            HEX4 = 7'b0001100;
        end else if (down == 1) begin
            // DO
            HEX5 = 7'b0100001;
            HEX4 = 7'b0100011;
        end else begin
            // off
            HEX5 = 7'b1111111;
            HEX4 = 7'b1111111;
        end
        
        // Middle hex (left/right)
        if (left == 1) begin
            // LE
            HEX3 = 7'b1000111;
            HEX2 = 7'b0000110;
        end else if (right == 1) begin
            // RI
            HEX3 = 7'b1001110;
            HEX2 = 7'b1001111;
        end else begin
            // off
            HEX3 = 7'b1111111;
            HEX2 = 7'b1111111;
        end        
        
        // right hex (A and B)
        if (b == 1) begin
            // B
            HEX1 = 7'b0000011;
        end else begin
            // off
            HEX1 = 7'b1111111;
        end     
        
        if (a == 1) begin
            // A
            HEX0 = 7'b0001000;
        end else begin
            // off
            HEX0 = 7'b1111111;
        end        
        

    end
    
endmodule

