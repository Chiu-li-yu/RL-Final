module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    logic q_internal;
    always @(*) begin
        q_internal = b | c;
    end
    assign q = q_internal;
endmodule
