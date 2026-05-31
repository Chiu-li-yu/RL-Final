module TopModule(
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

    always @(posedge clk) begin
        if (reset) begin
            state <= BYTE1;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        done = 1'b0;

        case (state)
            BYTE1: begin
                if (in[3]) next_state = BYTE2;
                else next_state = BYTE1;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                // The signal done is high in the cycle AFTER byte 3 is received
                // This means done must be high if the CURRENT state is BYTE3
                // WAIT. No, the spec says "signal done in the cycle immediately AFTER 
                // the third byte of each message was successfully received".
                // This means the module should output 'done' when it is in state BYTE3
                // but the state BYTE3 refers to the state where the 3rd byte IS RECEIVED.
                // Let's re-read: "signal the receipt of a message once all 3 bytes 
                // have been received (done). The FSM should signal done in the cycle 
                // immediately after the third byte of each message was successfully received."
                
                // My logic:
                // Clock 1: Byte 1 (in[3]=1)
                // Clock 2: Byte 2
                // Clock 3: Byte 3
                // Clock 4: done=1
            end
        endcase
    end
endmodule