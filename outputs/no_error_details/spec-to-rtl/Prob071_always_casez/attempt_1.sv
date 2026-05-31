module TopModule (
    input [7:0] in,
    output [2:0] pos
);
    logic [2:0] p;

    always @(*) begin
        if (in[0])      p = 3'd0;
        else if (in[1]) p = 3'd1;
        else if (in[2]) p = 3'd2;
        else if (in[3]) p = 3'd3;
        else if (in[4]) p = 3'd4;
        else if (in[5]) p = 3'd5;
        else if (in[6]) p = 3'd6;
        else if (in[7]) p = 3'd7;
        else            p = 3'd0;
    end

    assign pos = p;
endmodule
