module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    logic [2:0] state, next_state;
    parameter IDLE = 3'd0;
    parameter START = 3'd1;
    parameter DATA = 3'd2;
    parameter STOP = 3'd3;

    logic [3:0] bit_cnt;
    logic [7:0] shift_reg;
    logic [7:0] data_reg;
    logic done_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 4'd0;
            shift_reg <= 8'd0;
            data_reg <= 8'd0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_cnt <= bit_cnt + 4'd1;
            end else begin
                bit_cnt <= 4'd0;
            end
            
            if (state == STOP && in == 1'b1) begin
                data_reg <= shift_reg;
                done_reg <= 1'b1;
            end else begin
                done_reg <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: next_state = (in == 1'b0) ? START : IDLE;
            START: next_state = DATA;
            DATA: next_state = (bit_cnt == 4'd7) ? STOP : DATA;
            STOP: next_state = (in == 1'b1) ? IDLE : (in == 1'b0 ? START : STOP);
            default: next_state = IDLE;
        endcase
    end

    assign out_byte = data_reg;
    assign done = done_reg;

endmodule
