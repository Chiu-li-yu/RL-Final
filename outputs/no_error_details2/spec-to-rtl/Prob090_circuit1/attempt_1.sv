module TopModule (
    input a,
    input b,
    output q
);
    logic q_val;
    always @(*) begin
        q_val = a & b;
    end
    assign q = q_val;
endmodule