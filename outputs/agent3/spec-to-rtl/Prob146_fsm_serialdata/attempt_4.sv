module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);
    // The problem describes a UART receiver where each bit is sampled at the clk rate.
    // Start bit: 0
    // 8 Data bits (LSB first)
    // Stop bit: 1
    // The FSM:
    // IDLE: Wait for start bit (0).
    // DATA: Collect 8 bits.
    // STOP: Expect 1.
    
    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3, WAIT = 4;
    logic [2:0] state, next_state;
    logic [3:0] cnt;
    logic [7:0] data;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            cnt <= 0;
            data <= 0;
            done <= 0;
            out_byte <= 0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    done <= 0;
                end
                DATA: begin
                    data <= {in, data[7:1]};
                    cnt <= cnt + 1;
                end
                STOP: begin
                    if (in) begin
                        done <= 1;
                        out_byte <= data;
                    end else begin
                        done <= 0;
                    end
                end
                default: done <= 0;
            endcase
            if (state != DATA) cnt <= 0;
        end
    end

    always @(*) begin
        case (state)
            IDLE: next_state = (in == 0) ? START : IDLE;
            START: next_state = DATA;
            DATA: next_state = (cnt == 7) ? STOP : DATA;
            STOP: next_state = (in == 1) ? IDLE : WAIT;
            WAIT: next_state = (in == 1) ? IDLE : WAIT;
            default: next_state = IDLE;
        endcase
    end
endmodule
