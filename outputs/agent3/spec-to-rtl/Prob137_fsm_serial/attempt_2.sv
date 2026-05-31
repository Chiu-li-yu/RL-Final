module TopModule (
    input clk,
    input reset,
    input in,
    output logic done
);

    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3, WAIT_STOP = 4;
    logic [2:0] state, next_state;
    logic [3:0] bit_count;

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (in == 0) next_state = START;
            START: next_state = DATA;
            DATA: if (bit_count == 7) next_state = STOP;
            STOP: next_state = (in == 1) ? IDLE : WAIT_STOP;
            WAIT_STOP: if (in == 1) next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            
            if (state == IDLE) begin
                bit_count <= 0;
                done <= 0;
            end else if (state == DATA) begin
                bit_count <= bit_count + 1;
            end
            
            if (state == STOP && next_state == IDLE)
                done <= 1;
            else
                done <= 0;
        end
    end
endmodule