module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    logic [3:0] state, next_state;
    // S0: 0, S1: 1, S2: 11, S3: 111, S4: 1111, S5: 11111
    // DISC_S: 0111110, FLAG_S: 01111110, ERR_S: 01111111...
    localparam S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5, S6 = 4'd6, S7 = 4'd7, DISC_S = 4'd8, FLAG_S = 4'd9, ERR_S = 4'd10;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : DISC_S;
            S6: next_state = in ? S7 : FLAG_S;
            S7: next_state = in ? S7 : ERR_S;
            DISC_S: next_state = in ? S1 : S0;
            FLAG_S: next_state = in ? S1 : S0;
            ERR_S: next_state = in ? ERR_S : S0; // Keep ERR_S until a 0
            default: next_state = S0;
        endcase
    end

    always_comb begin
        disc = (state == DISC_S);
        flag = (state == FLAG_S);
        err  = (state == ERR_S);
    end

endmodule
