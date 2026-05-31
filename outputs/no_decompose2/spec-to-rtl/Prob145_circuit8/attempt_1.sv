module TopModule (
    input logic clock,
    input logic a,
    output logic p,
    output logic q
);
    logic q_prev;

    always_ff @(posedge clock) begin
        p <= a;
        q_prev <= p;
    end

    assign q = q_prev;
endmodule
