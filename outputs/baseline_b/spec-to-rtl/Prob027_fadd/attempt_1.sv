module TopModule (
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    logic s1;
    logic c1;
    logic c2;

    always @(*) begin
        // Full adder logic:
        // sum = a ^ b ^ cin
        // cout = (a & b) | (cin & (a ^ b))
        
        sum = a ^ b ^ cin;
        cout = (a & b) | (cin & (a ^ b));
    end

endmodule