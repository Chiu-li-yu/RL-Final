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
        ERROR = 3'd4
    } state_t;

    state_t state, next_state;
    logic [3:0] count, next_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 4'd0;
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
                if (in == 1'b0) begin
                    next_state = DATA;
                    next_count = 4'd0;
                end
            end
            DATA: begin
                if (count < 4'd8) begin
                    next_count = count + 4'd1;
                end else begin
                    next_state = STOP;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
