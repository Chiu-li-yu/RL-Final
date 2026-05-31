module TopModule (
    input a,
    input b,
    output q
);
    logic q_int;
    always @(*) begin
        q_int = a & b;
    end
    assign q = q_int;
endmodule
