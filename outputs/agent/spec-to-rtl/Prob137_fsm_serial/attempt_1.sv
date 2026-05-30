module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    typedef enum logic [2:0] {
        IDLE  = 3'd0,
        DATA  = 3'd1,
        STOP  = 3'd2,
        WAIT  = 3'd3
    } state_t;

    logic [2:0] state, next_state;
    logic [3:0] count;
    logic done_r;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 4'd0;
            done_r <= 1'b0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                count <= count + 1'b1;
            end else begin
                count <= 4'd0;
            end
            
            if (state == STOP && in == 1'b1) begin
                done_r <= 1'b1;
            end else begin
                done_r <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = DATA;
                end
            end
            DATA: begin
                if (count == 4'd7) begin
                    next_state = STOP;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT;
                end
            end
            WAIT: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    assign done = done_r;

endmodule
