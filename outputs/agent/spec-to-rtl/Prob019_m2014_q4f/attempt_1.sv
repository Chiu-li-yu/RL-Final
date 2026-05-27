module TopModule (
    input  in1,
    input  in2,
    output out
);
    logic out_temp;
    always @(*) begin
        out_temp = in1 & (~in2);
    end
    assign out = out_temp;
endmodule
