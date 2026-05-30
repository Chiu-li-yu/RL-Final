module TopModule (
    input in1,
    input in2,
    output out
);
    logic out_int;
    always @(*) begin
        out_int = in1 & (~in2);
    end
    assign out = out_int;
endmodule
