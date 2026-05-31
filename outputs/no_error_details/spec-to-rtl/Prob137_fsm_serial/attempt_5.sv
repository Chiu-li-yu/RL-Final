module TopModule (
    input clk,
    input reset,
    input in,
    output logic done
);
    localparam IDLE = 3'd0, START = 3'd1, DATA = 3'd2, STOP = 3'd3, WAIT = 3'd4;
    logic [2:0] state, next_state;
    logic [3:0] cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            cnt <= 0;
        end else begin
            state <= next_state;
            if (state == DATA) cnt <= cnt + 1'b1;
            else cnt <= 0;
        end
    end

    always_comb begin
        next_state = state;
        done = 1'b0;
        case (state)
            IDLE: if (~in) next_state = START;
            START: next_state = DATA;
            DATA: if (cnt == 4'd7) next_state = STOP;
            STOP: begin
                if (in) begin
                    next_state = IDLE;
                    done = 1'b1;
                end else next_state = WAIT;
            end
            WAIT: if (in) next_state = IDLE;
        endcase
    end
endmodule