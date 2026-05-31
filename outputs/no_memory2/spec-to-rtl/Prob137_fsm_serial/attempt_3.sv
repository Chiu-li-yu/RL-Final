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
    logic [3:0] bit_count;
    logic [7:0] data;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            data <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (state == START) begin
                bit_count <= 4'd0;
                done <= 1'b0;
            end else if (state == DATA) begin
                bit_count <= bit_count + 1'b1;
                data[bit_count] <= in;
            end else if (state == STOP) begin
                done <= (in == 1'b1);
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) next_state = START;
                else next_state = IDLE;
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 4'd7) next_state = STOP;
                else next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1) next_state = IDLE;
                else next_state = WAIT;
            end
            WAIT: begin
                if (in == 1'b1) next_state = IDLE;
                else next_state = WAIT;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
