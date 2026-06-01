module TopModule (
    input logic [3:0] in,
    output logic [1:0] pos
);
    // 規格: "outputs the position of the first 1 bit"
    // 4'b1000 -> pos 3
    // 4'b0100 -> pos 2
    // 4'b0010 -> pos 1
    // 4'b0001 -> pos 0
    // "if none... output zero"
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
