module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    logic s_sum;
    logic s_cout;

    always @(*) begin
        s_sum = a ^ b ^ cin;
        s_cout = (a & b) | (b & cin) | (a & cin);
    end

    assign sum = s_sum;
    assign cout = s_cout;

endmodule
