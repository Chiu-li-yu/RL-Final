module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);
    // UART protocol: Idle(1) -> Start(0) -> 8 Data (LSB first) -> Stop(1)
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
            
            case (next_state)
                DATA: begin
                    if (state == START) cnt <= 0;
                    else cnt <= cnt + 1;
                    data <= (state == START) ? {in, 7'b0} : {in, data[7:1]};
                end
                STOP: begin
                    if (in) begin
                        done <= 1;
                        out_byte <= data;
                    end else begin
                        done <= 0;
                    end
                end
                default: begin
                    done <= 0;
                end
            endcase
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
