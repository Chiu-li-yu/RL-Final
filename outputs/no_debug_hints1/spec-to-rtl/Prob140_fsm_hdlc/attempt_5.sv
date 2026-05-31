module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    logic [3:0] state, next_state;
    // Moore FSM states
    localparam S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5, S6 = 4'd6, S7 = 4'd7, S_DISC = 4'd8, S_FLAG = 4'd9, S_ERR = 4'd10;

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
            S5: next_state = in ? S6 : S_DISC;
            S6: next_state = in ? S7 : S_FLAG;
            S7: next_state = in ? S_ERR : S_FLAG;
            S_DISC: next_state = in ? S1 : S0;
            S_FLAG: next_state = in ? S1 : S0;
            S_ERR: next_state = in ? S_ERR : S0;
            default: next_state = S0;
        endcase
    end

    always_comb begin
        disc = (state == S_DISC);
        flag = (state == S_FLAG);
        err  = (state == S_ERR);
    end

endmodule
