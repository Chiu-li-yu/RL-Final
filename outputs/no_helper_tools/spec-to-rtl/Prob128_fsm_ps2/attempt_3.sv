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

    always_ff @(posedge clk) begin
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
                // The done signal should be high when in BYTE3,
                // meaning the third byte was just read.
                // The next state is determined by whether the next byte is a potential new byte 1.
                // Wait, if we are in BYTE3, this cycle we received the 3rd byte.
                // We signal done in the current cycle.
                // The next cycle we check the new input byte.
                done = 1'b1;
                if (in[3]) begin
                    next_state = BYTE2;
                end else begin
                    next_state = BYTE1;
                end
            end
        endcase
    end
endmodule
