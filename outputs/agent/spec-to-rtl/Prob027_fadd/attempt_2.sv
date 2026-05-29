module TopModule (
    input a,
    input b,
    input cin,
    output logic cout,
    output logic sum
);

    always @(*) begin
        sum = a ^ b ^ cin;
        cout = (a & b) | (b & cin) | (a & cin);
    end

endmodule
