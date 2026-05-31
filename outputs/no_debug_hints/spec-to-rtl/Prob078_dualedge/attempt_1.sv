module TopModule (
    input clk,
    input d,
    output q
);
    logic q1, q2;

    always @(posedge clk) begin
        q1 <= d ^ q2;
    end

    always @(negedge clk) begin
        q2 <= d ^ q1;
    end

    assign q = q1 ^ q2;
endmodule