module TopModule (
    input logic clk,
    input logic in,
    input logic reset,
    output logic [7:0] out_byte,
    output logic done
);
    localparam IDLE = 0, RECEIVE = 1, STOP = 2;

    logic [1:0] state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            bit_cnt <= 3'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in == 1'b0) begin
                        state <= RECEIVE;
                        bit_cnt <= 3'b0;
                    end
                end
                RECEIVE: begin
                    shift_reg[bit_cnt] <= in;
                    if (bit_cnt == 3'd7) begin
                        state <= STOP;
                    end else begin
                        bit_cnt <= bit_cnt + 1'b1;
                    end
                end
                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        // Stay in STOP until in is 1
                        state <= STOP;
                    end
                end
            endcase
        end
    end
endmodule
