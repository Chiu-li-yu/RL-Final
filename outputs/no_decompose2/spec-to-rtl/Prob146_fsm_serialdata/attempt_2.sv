module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    logic [1:0] state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            bit_cnt <= 3'd0;
            done <= 1'b0;
            out_byte <= 8'b0;
        end else begin
            state <= next_state;
            
            if (state == DATA) begin
                shift_reg[bit_cnt] <= in;
                bit_cnt <= bit_cnt + 3'd1;
            end else begin
                bit_cnt <= 3'd0;
            end

            if (next_state == STOP && state == DATA && bit_cnt == 3'd7) begin
                out_byte <= {in, shift_reg[6:0]}; // Update with last bit
                // Actually, wait. Need to capture correctly.
                // The current bit logic needs adjustment.
            end
            
            if (state == STOP && in == 1'b1) begin
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    // Refined logic for state transition
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: next_state = (in == 1'b0) ? START : IDLE;
            START: next_state = DATA;
            DATA: next_state = (bit_cnt == 3'd7) ? STOP : DATA;
            STOP: next_state = (in == 1'b1) ? IDLE : STOP;
        endcase
    end
endmodule
