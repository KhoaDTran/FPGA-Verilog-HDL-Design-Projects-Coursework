module n8_driver (
    input clk,
    input data_in,
    output reg latch,
    output reg pulse,
    output reg up,
    output reg down,
    output reg left,
    output reg right,
    output reg select,
    output reg start,
    output reg a,
    output reg b);
    
    // localparam SPEED = 15; // Fast 
    localparam SPEED = 17; // Slow (and visible)
    reg [8:0] count;
    reg[7:0] temp; // The register to be saved. 
                   // We start from right to the left, so the first bit (0) will be A, the second B, the third select, etc.
                   // So bit 7 will be right and bit 0 will be A
                   // However, this is only true when the process of shifting all is finished. At any time it will be moving
                   // the data from 0 to 7
                   
    reg save; // Either 1 (saving temp[7:0] to LED's 0:7) or 0 (not saving)

    //pulse and latch generation
    always@* begin
    
        // For the first 20 options:
        if (count < 20) begin
            //count 0
            if(count == 0) begin 
                latch = 0; pulse = 0; save = 0; 
            end
            //count 1, 2
            else if ((count == 1) | (count == 2)) begin
                latch = 1; pulse = 0; save = 0; 
            end
            //count 18
            else if (count == 18) begin 
                latch = 0; pulse = 1; save = 0; 
            end
            //count 19
            else if (count == 19) begin 
                latch = 0; pulse = 0; save = 1; 
            end
            //count 3, 5, 7, 9, 11, 13, 15, 17
            else if (count[0]) begin 
                latch = 0; pulse = 0; save = 0; 
            end
            //count 4, 6, 8, 10, 12, 14, 16, 18
            else /* (~count[0])*/ begin 
                latch = 0; pulse = 1; save = 0; 
            end
            //count >18
        end
        else begin 
                latch = 0; pulse = 0; save = 0;
        end
    end

    // Whenever either N8_PULSE or N8_LATCH become negative from positive
    // then do the left shifting of one bit. The reason for doing it
    // in negedge and not in posedge is because doing it in posedge assumes
    // that the request by the Raspberry Pi must be extremely fast.
    // My understanding is that the answer by the Raspberry Pi must be
    // at least 1/50M seconds, as once the previous block changes from
    // N8_PULSE 0 to 1, immediately this code is triggered. However,
    // if we do negedge (as we do here), thanks to the counter it will
    // process it in a longer time (depending on "SPEED"), which gives
    // room to the Raspberry Pi to process it in a millisecond or similar
    always @(negedge latch | pulse)
    begin
        temp[7:1] <= temp[6:0];
        temp[0] <= data_in;
    end

    // When save is true, then save in the LED's
    // It's going to be:
    // LEDR[7] = right
    // LEDR[6] = left
    // LEDR[5] = down
    // LEDR[4] = up
    // LEDR[3] = start
    // LEDR[2] = select
    // LEDR[1] = b
    // LEDR[0] = a
    always @(posedge save) 
    begin
        right  = ~temp[0];
        left   = ~temp[1];
        down   = ~temp[2];
        up     = ~temp[3];
        start  = ~temp[4];
        select = ~temp[5];
        b      = ~temp[6];
        a      = ~temp[7];
    end
    
    reg [SPEED:0] counter;
    always@(posedge clk) counter <= counter + 1;

    // counter... 30 low number of positions (e.g. 0..30)
    always@(posedge counter[SPEED]) begin
        if (count == 30)
            count <= 0;
        else
            count <= count + 1;
    end
    
endmodule
    