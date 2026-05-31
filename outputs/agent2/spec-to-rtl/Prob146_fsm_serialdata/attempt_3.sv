module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    localparam IDLE = 0, DATA = 1, STOP = 2, DONE_STATE = 3;
    logic [1:0] state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    // FSM needs to sample bits correctly. 
    // Usually serial data is sampled in the middle of a bit period, 
    // but here we just need to follow the bit-stream.
    
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 0;
        end else begin
            state <= next_state;
            case (next_state)
                DATA: begin
                    if (state == DATA) begin
                        shift_reg <= {in, shift_reg[7:1]};
                        bit_cnt <= bit_cnt + 1;
                    end else begin
                        bit_cnt <= 0;
                    end
                end
                DONE_STATE: begin
                    out_byte <= shift_reg;
                    done <= 1;
                end
                default: begin
                    done <= 0;
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (in == 0) next_state = DATA;
            DATA: if (bit_cnt == 7) next_state = STOP;
            STOP: if (in == 1) next_state = DONE_STATE; else next_state = IDLE;
            DONE_STATE: next_state = IDLE;
        endcase
    end
endmodule
