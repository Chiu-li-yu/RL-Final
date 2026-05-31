module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);
    // The current implementation is too fast (sampling every clock).
    // The problem describes a UART-like protocol, but doesn't explicitly mention baud rate.
    // However, given the nature of these problems, typically it expects one bit per clock
    // cycle if no baud divider is mentioned, OR there's a specific timing requirement.
    // Looking at the mismatch, it suggests the logic might be sampling wrong.
    
    // Let's re-read: "it will identify when bytes have been correctly received when given a stream of bits."
    // "One common scheme is to use one start bit (0), 8 data bits, and 1 stop bit (1)."
    // It doesn't say "oversampling". I will assume 1 bit per clock cycle.

    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        STOP,
        WAIT_STOP
    } state_t;

    state_t state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_byte <= 8'b0;
            done <= 1'b0;
            shift_reg <= 8'b0;
            bit_cnt <= 3'b0;
        end else begin
            done <= 1'b0;
            case (state)
                IDLE: begin
                    if (in == 1'b0) state <= START;
                end
                START: begin
                    state <= DATA;
                    bit_cnt <= 3'b0;
                end
                DATA: begin
                    shift_reg[bit_cnt] <= in;
                    if (bit_cnt == 3'd7) state <= STOP;
                    else bit_cnt <= bit_cnt + 1'b1;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end
                WAIT_STOP: begin
                    if (in == 1'b1) state <= IDLE;
                end
            endcase
        end
    end
endmodule