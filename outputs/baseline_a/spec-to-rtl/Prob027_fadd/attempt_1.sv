module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    logic s;
    logic c;

    always @(*) begin
        s = a ^ b ^ cin;
        c = (a & b) | (b & cin) | (a & cin);
    end

    assign sum = s;
    assign cout = c;

endmodule
