module TopModule(
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    typedef enum logic [2:0] {
        IDLE = 3'd0,
        START = 3'd1,
        DATA = 3'd2,
        STOP = 3'd3
    } state_t;

    state_t state, next_state;
    logic [2:0] bit_cnt;
    logic [7:0] shift_reg;
    logic [7:0] next_out_byte;
    logic next_done;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                bit_cnt <= bit_cnt + 3'd1;
                shift_reg <= {in, shift_reg[7:1]};
            end else if (state == START) begin
                bit_cnt <= 3'd0;
            end
            
            if (next_done) begin
                out_byte <= next_out_byte;
            end
            done <= next_done;
        end
    end

    always @(*) begin
        next_state = state;
        next_done = 1'b0;
        next_out_byte = out_byte;

        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = DATA;
            end
            DATA: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1) begin
                    next_done = 1'b1;
                    next_out_byte = shift_reg;
                    next_state = IDLE;
                end else begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
