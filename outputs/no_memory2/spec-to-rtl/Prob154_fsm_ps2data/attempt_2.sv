module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);
    typedef enum logic [1:0] {
        STATE_IDLE = 2'd0,
        STATE_BYTE2 = 2'd1,
        STATE_BYTE3 = 2'd2
    } state_t;

    state_t state, next_state;
    logic [23:0] buffer, next_buffer;
    logic next_done;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= STATE_IDLE;
            buffer <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            buffer <= next_buffer;
            done <= next_done;
        end
    end

    always @(*) begin
        next_state = state;
        next_buffer = buffer;
        next_done = 1'b0;
        out_bytes = buffer;

        case (state)
            STATE_IDLE: begin
                if (in[3]) begin
                    next_buffer[23:16] = in;
                    next_state = STATE_BYTE2;
                end
            end
            STATE_BYTE2: begin
                next_buffer[15:8] = in;
                next_state = STATE_BYTE3;
            end
            STATE_BYTE3: begin
                next_buffer[7:0] = in;
                out_bytes = {buffer[23:16], buffer[15:8], in};
                next_done = 1'b1;
                next_state = STATE_IDLE;
            end
        endcase
    end
endmodule