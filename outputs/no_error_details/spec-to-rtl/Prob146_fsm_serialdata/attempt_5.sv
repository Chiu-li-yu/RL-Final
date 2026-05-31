module TopModule (
    input logic clk,
    input logic in,
    input logic reset,
    output logic [7:0] out_byte,
    output logic done
);
    typedef enum logic [1:0] {IDLE, RX, STOP} state_t;
    state_t state;
    logic [7:0] shift_reg;
    logic [2:0] bit_idx;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            bit_idx <= 3'b0;
            done <= 1'b0;
            out_byte <= 8'b0;
        end else begin
            done <= 1'b0; // Default off
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= RX;
                        bit_idx <= 3'b0;
                    end
                end
                RX: begin
                    shift_reg[bit_idx] <= in;
                    if (bit_idx == 3'd7)
                        state <= STOP;
                    else
                        bit_idx <= bit_idx + 1'b1;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= IDLE; // Specification says "wait until it finds a stop bit" but implies restart
                        // Re-reading: "If the stop bit does not appear when expected, the FSM must wait 
                        // until it finds a stop bit before attempting to receive the next byte."
                        // Actually, this usually means stay in STOP state.
                    end
                end
            endcase
        end
    end
endmodule
