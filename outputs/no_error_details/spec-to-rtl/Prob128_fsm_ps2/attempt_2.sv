module TopModule (
    input logic clk,
    input logic reset,
    input logic [7:0] in,
    output logic done
);

    typedef enum logic [1:0] {
        SEARCH = 2'b00,
        BYTE2  = 2'b01,
        BYTE3  = 2'b10
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        done = 1'b0;

        case (state)
            SEARCH: begin
                if (in[3]) begin
                    next_state = BYTE2;
                end else begin
                    next_state = SEARCH;
                end
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                // In the cycle after the 3rd byte is received, signal done.
                // If we are in BYTE3, it means the 3rd byte was just received in the previous cycle
                // OR we are currently in the cycle that should signal done?
                // The prompt says: "signal done in the cycle immediately after the third byte of each message was successfully received"
            end
            default: next_state = SEARCH;
        endcase
    end

    // Let's re-think the state machine to be output-ready at the correct timing.
    // If we receive byte1 in cycle N, byte2 in N+1, byte3 in N+2.
    // done should be 1 in cycle N+3.
endmodule