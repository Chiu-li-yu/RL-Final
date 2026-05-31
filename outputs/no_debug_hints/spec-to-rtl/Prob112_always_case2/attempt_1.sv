module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    logic [1:0] pos_next;

    always @(*) begin
        if (in[3]) begin
            pos_next = 2'd3;
        end else if (in[2]) begin
            pos_next = 2'd2;
        end else if (in[1]) begin
            pos_next = 2'd1;
        end else if (in[0]) begin
            pos_next = 2'd0;
        end else begin
            pos_next = 2'd0;
        end
    end

    assign pos = pos_next;

endmodule
