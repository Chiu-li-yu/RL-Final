module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3, WAIT_STOP = 4;
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
                bit_cnt <= 0;
            end else if (state == DATA) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_cnt <= bit_cnt + 1;
            end
            
            if (next_state == IDLE && state == STOP && in == 1'b1) begin
                out_byte <= {in, shift_reg[7:1]}; // Wait, this logic for shift_reg is wrong.
            end
        end
    end
    // Redesigning
endmodule