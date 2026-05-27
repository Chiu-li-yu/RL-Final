module TopModule (
    input  logic [7:0] in,
    output logic       parity
);

    always_comb begin
        parity = ^in;
    end

endmodule