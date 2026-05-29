
module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    localparam S0 = 3'd0,
               S1 = 3'd1,
               S2 = 3'd2,
               S3 = 3'd3,
               S4 = 3'd4;

    logic [2:0] state;
    logic shift_ena_comb;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            case (state)
                S0: state <= S1;
                S1: state <= S2;
                S2: state <= S3;
                S3: state <= S4;
                S4: state <= S4;
                default: state <= S4;
            endcase
        end
    end

    always @(*) begin
        case (state)
            S0, S1, S2, S3: shift_ena_comb = 1'b1;
            default: shift_ena_comb = 1'b0;
        endcase
    end

    assign shift_ena = shift_ena_comb;

endmodule
