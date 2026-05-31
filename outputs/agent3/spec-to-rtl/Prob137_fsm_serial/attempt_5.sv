module TopModule (
    input clk,
    input reset,
    input in,
    output logic done
);

    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3, WAIT_STOP = 4;
    logic [2:0] state, next_state;
    logic [3:0] count;

    always @(*) begin
        case (state)
            IDLE: next_state = (in == 0) ? START : IDLE;
            START: next_state = DATA;
            DATA: next_state = (count == 7) ? STOP : DATA;
            STOP: next_state = (in == 1) ? IDLE : WAIT_STOP;
            WAIT_STOP: next_state = (in == 1) ? IDLE : WAIT_STOP;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            if (state == DATA) count <= count + 1;
            else count <= 0;

            if (state == STOP && in == 1) done <= 1;
            else done <= 0;
        end
    end
endmodule