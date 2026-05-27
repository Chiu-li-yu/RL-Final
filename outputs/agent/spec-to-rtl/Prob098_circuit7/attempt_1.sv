module TopModule (
    input logic clk,
    input logic a,
    output logic q
);

    logic [1:0] state;
    localparam S0 = 2'd0;
    localparam S1 = 2'd1;
    localparam S2 = 2'd2;

    always_ff @(posedge clk) begin
        case (state)
            S0: begin
                if (a == 1'b0) state <= S1;
                else state <= S0;
            end
            S1: begin
                if (a == 1'b1) state <= S2;
                else state <= S1;
            end
            S2: begin
                if (a == 1'b1) state <= S2;
                else state <= S1;
            end
            default: state <= S0;
        endcase
    end

    always_comb begin
        case (state)
            S0: q = 1'bx;
            S1: q = 1'b1;
            S2: q = 1'b0;
            default: q = 1'bx;
        endcase
    end

endmodule
