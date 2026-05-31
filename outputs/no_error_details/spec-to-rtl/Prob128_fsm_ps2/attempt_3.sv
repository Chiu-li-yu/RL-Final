module TopModule (
    input logic clk,
    input logic reset,
    input logic [7:0] in,
    output logic done
);

    // States:
    // SEARCH: waiting for in[3] == 1
    // BYTE2: received byte 1, now in cycle of byte 2
    // BYTE3: received byte 2, now in cycle of byte 3
    // DONE: signaled done, transition back to SEARCH

    typedef enum logic [1:0] {
        SEARCH = 2'b00,
        BYTE2  = 2'b01,
        BYTE3  = 2'b10,
        DONE   = 2'b11
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
                if (in[3]) next_state = BYTE2;
                else       next_state = SEARCH;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = DONE;
            end
            DONE: begin
                done = 1'b1;
                // Transition to SEARCH or directly to BYTE2 if the byte is a start byte?
                // The spec says: "The FSM should signal done in the cycle immediately after the third byte of each message was successfully received."
                // "The algorithm we'll use is to discard bytes until we see one with in[3]=1."
                // This implies the cycle after DONE might be a new byte.
                if (in[3]) next_state = BYTE2;
                else       next_state = SEARCH;
            end
        endcase
    end
endmodule