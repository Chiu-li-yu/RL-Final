module TopModule(
    input  clk,
    input  d,
    output q
);

    logic q_posedge;
    logic q_negedge;
    logic q_final;

    always_ff @(posedge clk) begin
        q_posedge <= d;
    end

    always_ff @(negedge clk) begin
        q_negedge <= d;
    end

    assign q_final = clk ? q_posedge : q_negedge;

    assign q = q_final;

endmodule