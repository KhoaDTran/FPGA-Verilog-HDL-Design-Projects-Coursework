module n8_example (
    input CLOCK_50,
    input N8_DATA_IN,
    output N8_LATCH,
    output N8_PULSE,
    output [9:0] LEDR,
    output [6:0] HEX0, 
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5);
    
    wire up;
    wire down;
    wire left;
    wire right;
    wire a;
    wire b;

    n8_driver driver(
        .clk(CLOCK_50),
        .data_in(N8_DATA_IN),
        .latch(N8_LATCH),
        .pulse(N8_PULSE),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .select(LEDR[9]),
        .start(LEDR[8]),
        .a(a),
        .b(b)
    );
    
    n8_display display(
        .clk(CLOCK_50),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .select(select),
        .start(start),
        .a(a),
        .b(b),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

endmodule

