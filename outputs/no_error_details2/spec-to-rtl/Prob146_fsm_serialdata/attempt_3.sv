module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    localparam IDLE = 3'd0, START = 3'd1, DATA = 3'd2, STOP = 3'd3, WAIT_STOP = 3'd4;
    logic [2:0] state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_byte <= 8'd0;
            done <= 1'b0;
            shift_reg <= 8'd0;
            bit_cnt <= 3'd0;
        end else begin
            state <= next_state;
            if (state == START) begin
                bit_cnt <= 3'd0;
            end else if (state == DATA) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_cnt <= bit_cnt + 1'b1;
            end
            
            if (state == STOP && in == 1'b1) begin
                out_byte <= shift_reg;
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE: next_state = (in == 1'b0) ? START : IDLE;
            START: next_state = DATA;
            DATA: next_state = (bit_cnt == 3'd7) ? STOP : DATA;
            STOP: next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            WAIT_STOP: next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            default: next_state = IDLE;
        endcase
    end
endmodule