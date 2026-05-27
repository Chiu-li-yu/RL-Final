module TopModule (
    input  logic [3:0] in,
    output logic [1:0] pos
);
    // The requirement states: "the position of the first 1 bit in the vector".
    // Example: 8'b10010000 -> 3'd4 (bit[4] is the first 1).
    // So if 4'b0010 (bit[1] is high), pos should be 2'd1.
    // If 4'b0100 (bit[2] is high), pos should be 2'd2.
    // If 4'b1000 (bit[3] is high), pos should be 2'd3.
    // Let's re-verify the input logic order.
    
    always @(*) begin
        if (in[3]) 
            pos = 2'd3;
        else if (in[2]) 
            pos = 2'd2;
        else if (in[1]) 
            pos = 2'd1;
        else if (in[0]) 
            pos = 2'd0;
        else 
            pos = 2'd0;
    end
endmodule
