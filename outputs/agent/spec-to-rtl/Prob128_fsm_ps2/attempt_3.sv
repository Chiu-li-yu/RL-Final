module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic done
);

    typedef enum logic [1:0] {
        BYTE1 = 2'd0,
        BYTE2 = 2'd1,
        BYTE3 = 2'd2
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= BYTE1;
        end else begin
            state <= next_state;
        end
    end

    // The FSM needs to correctly identify the start byte and track the 3-byte sequence.
    always @(*) begin
        case (state)
            BYTE1: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = BYTE1;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = BYTE1;
            end
            default: next_state = BYTE1;
        endcase
    end

    // The specification: "signal done in the cycle immediately after 
    // the third byte of each message was successfully received."
    // If the 3rd byte is received in cycle T, then state becomes BYTE3 at the start of cycle T+1.
    // Done should be high at T+1.
    
    always @(*) begin
        if (state == BYTE3) begin
            done = 1'b1;
        end else begin
            done = 1'b0;
        end
    end

endmodule
