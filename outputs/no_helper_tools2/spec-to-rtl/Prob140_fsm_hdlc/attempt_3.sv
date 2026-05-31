module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    logic [3:0] state, next_state;
    localparam S_IDLE = 4'd0, S_1 = 4'd1, S_11 = 4'd2, S_111 = 4'd3, S_1111 = 4'd4, 
               S_11111 = 4'd5, S_DISC = 4'd6, S_FLAG = 4'd7, S_ERR = 4'd8;

    always_ff @(posedge clk) begin
        if (reset) state <= S_IDLE;
        else state <= next_state;
    end

    always_comb begin
        case (state)
            S_IDLE: next_state = in ? S_1 : S_IDLE;
            S_1:    next_state = in ? S_11 : S_IDLE;
            S_11:   next_state = in ? S_111 : S_IDLE;
            S_111:  next_state = in ? S_1111 : S_IDLE;
            S_1111: next_state = in ? S_11111 : S_IDLE;
            S_11111: next_state = in ? S_FLAG : S_DISC;
            S_DISC:  next_state = in ? S_1 : S_IDLE;
            S_FLAG:  next_state = in ? S_ERR : S_IDLE;
            S_ERR:   next_state = in ? S_ERR : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            disc <= (next_state == S_DISC);
            flag <= (next_state == S_FLAG);
            err  <= (next_state == S_ERR);
        end
    end
endmodule
