module TopModule (
    input clk,
    input j,
    input k,
    output logic Q
);

    logic next_q;

    always @(*) begin
        case ({j, k})
            2'b00: next_q = Q;
            2'b01: next_q = 1'b0;
            2'b10: next_q = 1'b1;
            2'b11: next_q = ~Q;
            default: next_q = Q;
        endcase
    end

    always @(posedge clk) begin
        Q <= next_q;
    end

endmodule
