module TopModule(
    input [7:0] in,
    output [2:0] pos
);

    logic [2:0] pos_val;

    always @(*) begin
        if (in[0])      pos_val = 3'd0;
        else if (in[1]) pos_val = 3'd1;
        else if (in[2]) pos_val = 3'd2;
        else if (in[3]) pos_val = 3'd3;
        else if (in[4]) pos_val = 3'd4;
        else if (in[5]) pos_val = 3'd5;
        else if (in[6]) pos_val = 3'd6;
        else if (in[7]) pos_val = 3'd7;
        else            pos_val = 3'd0;
    end

    assign pos = pos_val;

endmodule
