module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    localparam S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5, S6 = 4'd6, S7 = 4'd7, S_ERR = 4'd8;
    logic [3:0] current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    always_comb begin
        case (current_state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S2 : S0;
            S2: next_state = (in) ? S3 : S0;
            S3: next_state = (in) ? S4 : S0;
            S4: next_state = (in) ? S5 : S0;
            S5: next_state = (in) ? S6 : S0;
            S6: next_state = (in) ? S7 : S0;
            S7: next_state = (in) ? S_ERR : S0;
            S_ERR: next_state = S_ERR;
            default: next_state = S0;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
            
            if (current_state == S5 && in == 1'b0) disc <= 1'b1;
            if (current_state == S6 && in == 1'b0) flag <= 1'b1;
            if (next_state == S_ERR) err <= 1'b1;
        end
    end

endmodule