
module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    localparam IDLE      = 2'd0;
    localparam DATA      = 2'd1;
    localparam STOP      = 2'd2;
    localparam WAIT_STOP = 2'd3;

    logic [1:0] state;
    logic [2:0] bit_cnt;
    logic [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // Default value
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= DATA;
                        bit_cnt <= 3'd0;
                    end
                end

                DATA: begin
                    shift_reg[bit_cnt] <= in;
                    if (bit_cnt == 3'd7) begin
                        state <= STOP;
                        bit_cnt <= 3'd0;
                    end else begin
                        bit_cnt <= bit_cnt + 3'd1;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                        done <= 1'b1;
                        out_byte <= shift_reg;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                        done <= 1'b1;
                        out_byte <= shift_reg; // don't care
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
