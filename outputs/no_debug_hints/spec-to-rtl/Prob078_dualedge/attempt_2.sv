module TopModule (
    input clk,
    input d,
    output q
);
    logic q_posedge, q_negedge;

    always @(posedge clk) begin
        q_posedge <= d ^ q_negedge;
    end

    always @(negedge clk) begin
        q_negedge <= d ^ q_posedge;
    end

    assign q = q_posedge ^ q_negedge;
endmodule