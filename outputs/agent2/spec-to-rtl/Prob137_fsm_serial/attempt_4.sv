module TopModule (
    input clk,
    input reset,
    input in,
    output logic done
);

    localparam IDLE = 0, START = 1, DATA0 = 2, DATA1 = 3, DATA2 = 4, DATA3 = 5, DATA4 = 6, DATA5 = 7, DATA6 = 8, DATA7 = 9, STOP = 10, WAIT_STOP = 11;
    logic [3:0] state, next_state;

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (in == 0) next_state = START;
            START: next_state = DATA0;
            DATA0: next_state = DATA1;
            DATA1: next_state = DATA2;
            DATA2: next_state = DATA3;
            DATA3: next_state = DATA4;
            DATA4: next_state = DATA5;
            DATA5: next_state = DATA6;
            DATA6: next_state = DATA7;
            DATA7: next_state = STOP;
            STOP: next_state = (in == 1) ? IDLE : WAIT_STOP;
            WAIT_STOP: if (in == 1) next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
        end else begin
            state <= next_state;
            if (state == STOP && in == 1)
                done <= 1;
            else
                done <= 0;
        end
    end
endmodule