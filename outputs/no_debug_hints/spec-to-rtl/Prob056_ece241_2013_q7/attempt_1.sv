module TopModule (
    input clk,
    input j,
    input k,
    output logic Q
);

    logic next_Q;

    always_ff @(posedge clk) begin
        Q <= next_Q;
    end

    always_@(*) begin
        case ({j, k})
            2'b00: next_Q = Q;
            2'b01: next_Q = 1'b0;
            2'b10: next_Q = 1'b1;
            2'b11: next_Q = ~Q;
            default: next_Q = Q;
        endcase
    end

endmodule
