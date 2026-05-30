module TopModule (
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] s,
    output logic overflow
);

    logic [8:0] sum;

    always @(*) begin
        sum = {a[7], a} + {b[7], b};
        s = sum[7:0];
        
        // Overflow occurs if signs of inputs are the same but different from the result's sign
        // or more simply: (a[7] == b[7]) && (s[7] != a[7])
        if ((a[7] == b[7]) && (s[7] != a[7])) begin
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end
    end

endmodule
