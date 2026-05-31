module TopModule (
    input a,
    input b,
    output out
);

    always @(*) begin
        out = ~(a | b);
    end

endmodule