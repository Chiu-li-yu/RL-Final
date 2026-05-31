module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);
    logic [3:0] state;
    logic [3:0] delay;
    logic [2:0] bit_cnt;
    logic [13:0] timer_cnt;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            count <= 0;
            counting <= 0;
            done <= 0;
            bit_cnt <= 0;
            timer_cnt <= 0;
        end else begin
            case (state)
                0: if (data) state <= 1;
                1: if (data) state <= 2; else state <= 0;
                2: if (!data) state <= 3;
                3: if (data) begin state <= 4; bit_cnt <= 0; delay <= 0; end else state <= 0;
                4: begin
                    delay <= {delay[2:0], data};
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 3) begin
                        state <= 5;
                        count <= {delay[2:0], data};
                        timer_cnt <= 999;
                        counting <= 1;
                    end
                end
                5: begin
                    if (timer_cnt == 0) begin
                        if (count == 0) begin
                            state <= 6;
                            counting <= 0;
                            done <= 1;
                        end else begin
                            count <= count - 1;
                            timer_cnt <= 999;
                        end
                    end else timer_cnt <= timer_cnt - 1;
                end
                6: if (ack) begin state <= 0; done <= 0; end
            endcase
        end
    end
endmodule
