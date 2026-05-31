module TopModule (
    input a,
    input b,
    output q
);
    logic q_internal;
    always @(*) begin
        q_internal = a & b;
    end
    assign q = q_internal;
endmodule
