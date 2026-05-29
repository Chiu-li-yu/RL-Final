module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    logic q_next;

    always @(*) begin
        q_next = b | c;
    end

    assign q = q_next;
endmodule
