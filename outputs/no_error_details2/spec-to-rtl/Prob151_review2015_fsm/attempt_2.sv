module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output logic shift_ena,
    output logic counting,
    output logic done
);

    typedef enum logic [2:0] {
        IDLE = 3'd0,
        DETECT_0 = 3'd1,
        DETECT_1 = 3'd2,
        DETECT_2 = 3'd3,
        SHIFT = 3'd4,
        COUNTING = 3'd5,
        DONE = 3'd6
    } state_t;

    state_t state, next_state;
    logic [2:0] shift_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            shift_count <= 3'd0;
        end else if (state == SHIFT) begin
            shift_count <= shift_count + 1'b1;
        end else begin
            shift_count <= 3'd0;
        end
    end

    always @(*) begin
        next_state = state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (state)
            IDLE: next_state = (data) ? DETECT_1 : IDLE;
            DETECT_1: next_state = (data) ? DETECT_2 : IDLE;
            DETECT_2: next_state = (data) ? DETECT_2 : SHIFT; // Wait for 0 to confirm 110? No, sequence is 1101
            // Correction: Re-implement detection
            // The FSM needs to shift in 4 bits (1101)
        endcase
    end
endmodule