module TopModule (
    input logic [3:0] in,
    output logic [1:0] pos
);

    // The specification: "outputs the position of the first 1 bit in the vector."
    // Example: 4'b1000 -> 3 (index 3)
    //          4'b0100 -> 2
    //          4'b0010 -> 1
    //          4'b0001 -> 0
    //          4'b0000 -> 0

    always @(*) begin
        if (in[3])      pos = 2'd3;
        else if (in[2]) pos = 2'd2;
        else if (in[1]) pos = 2'd1;
        else if (in[0]) pos = 2'd0;
        else            pos = 2'd0;
    end

endmodule
