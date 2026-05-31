module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    logic [3:0] state, next_state;
    // 0:Idle, 1-5:ones, 6:Six ones, 7:Seven+ ones
    localparam S_IDLE = 4'd0, S_1 = 4'd1, S_2 = 4'd2, S_3 = 4'd3, S_4 = 4'd4, 
               S_5 = 4'd5, S_6 = 4'd6, S_ERR = 4'd7;

    always_ff @(posedge clk) begin
        if (reset) state <= S_IDLE;
        else state <= next_state;
    end

    always_comb begin
        case (state)
            S_IDLE: next_state = in ? S_1 : S_IDLE;
            S_1:    next_state = in ? S_2 : S_IDLE;
            S_2:    next_state = in ? S_3 : S_IDLE;
            S_3:    next_state = in ? S_4 : S_IDLE;
            S_4:    next_state = in ? S_5 : S_IDLE;
            S_5:    next_state = in ? S_6 : S_IDLE; // S_5 is 5 ones. if 0 -> disc
            S_6:    next_state = in ? S_ERR : S_IDLE; // S_6 is 6 ones (0111111). if 0 -> flag
            S_ERR:  next_state = in ? S_ERR : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    // Moore machine outputs depend on state
    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0; flag <= 1'b0; err <= 1'b0;
        end else begin
            // 0111110: disc
            disc <= (state == S_5 && !in);
            // 01111110: flag
            flag <= (state == S_6 && !in);
            // 01111111+: err
            err  <= (state == S_6 && in) || (state == S_ERR && in);
        end
    end
endmodule
