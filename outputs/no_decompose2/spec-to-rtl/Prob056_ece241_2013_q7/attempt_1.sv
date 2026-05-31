module TopModule (
    input clk,
    input j,
    input k,
    output logic Q
);

    logic Q_next;

    always @(posedge clk) begin
        Q <= Q_next;
    end

    always @(*) begin
        case ({j, k})
            2'b00: Q_next = Q;
            2'b01: Q_next = 1'b0;
            2'b10: Q_next = 1'b1;
            2'b11: Q_next = ~Q;
            default: Q_next = Q;
        endcase
    end

endmodule