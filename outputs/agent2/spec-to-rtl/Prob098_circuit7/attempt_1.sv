module TopModule (
    input clk,
    input a,
    output logic q
);
    logic q1, q2;

    always @(posedge clk) begin
        q1 <= ~a;
        q2 <= q1;
    end

    always @(*) begin
        q = q2;
    end
endmodule
