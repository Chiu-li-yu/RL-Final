module TopModule(
    input [3:0] in,
    output [1:0] pos
);
    logic [1:0] p;

    always @(*) begin
        if (in[3])
            p = 2'd3;
        else if (in[2])
            p = 2'd2;
        else if (in[1])
            p = 2'd1;
        else
            p = 2'd0;
    end

    assign pos = p;
endmodule