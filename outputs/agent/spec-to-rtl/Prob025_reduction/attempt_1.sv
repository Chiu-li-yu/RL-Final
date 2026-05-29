module TopModule (
    input  [7:0] in,
    output logic parity
);

    always @(*) begin
        parity = ^in;
    end

endmodule
