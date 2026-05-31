module TopModule (
    input clk,
    input reset,
    input in,
    output logic done
);
    typedef enum logic [2:0] {
        IDLE  = 3'd0,
        START = 3'd1,
        DATA  = 3'd2,
        STOP  = 3'd3,
        WAIT  = 3'd4
    } state_t;

    state_t state, next_state;
    logic [3:0] cnt;
    logic [3:0] next_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            cnt <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
            if (state == STOP && in == 1'b1)
                done <= 1'b1;
            else
                done <= 1'b0;
        end
    end

    always @(*) begin
        next_state = state;
        next_cnt = cnt;
        
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
            end
            START: begin
                next_state = DATA;
                next_cnt = 0;
            end
            DATA: begin
                if (cnt == 4'd7)
                    next_state = STOP;
                else
                    next_cnt = cnt + 1'b1;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT;
            end
            WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end
        endcase
    end
endmodule
