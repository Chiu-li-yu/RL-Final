module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    logic [1:0] pos_int;

    always @(*) begin
        // The problem states: "the position of the first 1 bit".
        // Usually, in a 4-bit encoder (bits 3,2,1,0):
        // If bit[3] is high, pos = 3
        // If bit[2] is high, pos = 2
        // If bit[1] is high, pos = 1
        // If bit[0] is high, pos = 0
        // If none high, pos = 0
        
        if (in[3]) 
            pos_int = 2'd3;
        else if (in[2]) 
            pos_int = 2'd2;
        else if (in[1]) 
            pos_int = 2'd1;
        else if (in[0]) 
            pos_int = 2'd0;
        else 
            pos_int = 2'd0;
    end

    assign pos = pos_int;

endmodule
