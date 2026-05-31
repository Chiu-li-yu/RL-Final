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
               S_11111 = 4'd5, S_6TH_1 = 4'd6, S_DISC = 4'd7, S_FLAG = 4'd8, S_ERR = 4'd9;

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
            S_11111: next_state = in ? S_6TH_1 : S_IDLE; // Got 5 ones, wait for 6th
            S_6TH_1: next_state = in ? S_ERR : S_FLAG;    // Got 6th one, if 1 it is 7th (err), if 0 it is flag (01111110)
            S_DISC:  next_state = in ? S_1 : S_IDLE;      // Previous logic wrong, let's fix.
            // Wait, let's re-evaluate the state machine.
            default: next_state = S_IDLE;
        endcase
    end
    // FSM re-design required.
endmodule
