module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    typedef enum logic [1:0] {
        IDLE = 2'd0,
        BYTE2 = 2'd1,
        BYTE3 = 2'd2
    } state_t;

    state_t state, next_state;
    logic [23:0] shift_reg, next_shift_reg;
    logic next_done;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            shift_reg <= next_shift_reg;
            done <= next_done;
        end
    end

    always @(*) begin
        next_state = state;
        next_shift_reg = shift_reg;
        next_done = 1'b0;
        out_bytes = shift_reg;

        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_shift_reg[23:16] = in;
                    next_state = BYTE2;
                end
            end
            BYTE2: begin
                next_shift_reg[15:8] = in;
                next_state = BYTE3;
            end
            BYTE3: begin
                next_shift_reg[7:0] = in;
                next_done = 1'b1;
                out_bytes = {shift_reg[23:16], shift_reg[15:8], in};
                
                // Transition logic: check if this byte is the start of a new message
                if (in[3]) begin
                    next_shift_reg[23:16] = in;
                    next_state = BYTE2;
                end else begin
                    next_state = IDLE;
                end
            end
        endcase
    end
endmodule
