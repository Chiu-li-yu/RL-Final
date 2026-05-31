module TopModule (
    input clk,
    input reset,
    input in,
    output logic done
);
    typedef enum logic [2:0] {
        IDLE,
        START,
        RECV,
        CHECK,
        WAIT
    } state_t;

    state_t state, next_state;
    logic [3:0] count;
    logic [3:0] next_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
        end else begin
            state <= next_state;
            count <= next_count;
        end
    end

    always @(*) begin
        next_state = state;
        next_count = count;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (!in) next_state = START;
            end
            START: begin
                next_state = RECV;
                next_count = 0;
            end
            RECV: begin
                next_count = count + 1;
                if (count == 3'd7) next_state = CHECK;
            end
            CHECK: begin
                if (in) begin
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_state = WAIT;
                end
            end
            WAIT: begin
                if (in) next_state = IDLE;
            end
        endcase
    end
endmodule