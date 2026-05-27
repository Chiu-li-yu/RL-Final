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

    always @(*) begin
        case (state)
            BYTE1: begin
                if (in[3]) begin
                    next_state = BYTE2;
                end else begin
                    next_state = BYTE1;
                end
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                if (in[3]) begin
                    next_state = BYTE2;
                end else begin
                    next_state = BYTE1;
                end
            end
            default: next_state = BYTE1;
        endcase
    end

    // The specification states: "The FSM should signal done in the cycle 
    // immediately after the third byte of each message was successfully received."
    // This means when we are in state BYTE3, we have successfully received the 3rd byte.
    // However, the transition to BYTE3 happens exactly when the 3rd byte is *being* provided.
    // Therefore, in the cycle AFTER receiving the 3rd byte (which is when the 
    // NEXT byte is being presented), we should be signaling done.
    
    // Correction:
    // Let's change the logic so that 'done' is high in the cycle immediately 
    // following the cycle where the 3rd byte is received.
    
    logic done_q;
    always_ff @(posedge clk) begin
        if (reset) begin
            done_q <= 1'b0;
        end else begin
            if (state == BYTE3) begin
                done_q <= 1'b1;
            end else begin
                done_q <= 1'b0;
            end
        end
    end

    assign done = done_q;

endmodule
