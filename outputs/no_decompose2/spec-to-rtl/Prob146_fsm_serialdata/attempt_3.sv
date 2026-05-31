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
            
            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    done <= 1'b0;
                end
                START: begin
                    bit_cnt <= 3'd0;
                    done <= 1'b0;
                end
                DATA: begin
                    shift_reg[bit_cnt] <= in;
                    bit_cnt <= bit_cnt + 3'd1;
                    done <= 1'b0;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        done <= 1'b1;
                        out_byte <= shift_reg;
                    end else begin
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE:  next_state = (in == 1'b0) ? START : IDLE;
            START: next_state = DATA;
            DATA:  next_state = (bit_cnt == 3'd7) ? STOP : DATA;
            STOP:  next_state = (in == 1'b1) ? IDLE : STOP;
        endcase
    end
endmodule
