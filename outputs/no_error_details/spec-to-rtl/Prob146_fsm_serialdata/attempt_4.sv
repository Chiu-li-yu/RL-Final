module TopModule (
    input logic clk,
    input logic in,
    input logic reset,
    output logic [7:0] out_byte,
    output logic done
);
    localparam S_IDLE = 0, S_START = 1, S_RECEIVE = 2, S_STOP = 3;

    logic [1:0] state;
    logic [7:0] data;
    logic [2:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            data <= 8'h00;
            count <= 3'd0;
            done <= 1'b0;
            out_byte <= 8'h00;
        end else begin
            case (state)
                S_IDLE: begin
                    done <= 1'b0;
                    if (in == 1'b0) state <= S_RECEIVE;
                end
                S_RECEIVE: begin
                    data[count] <= in;
                    if (count == 3'd7) state <= S_STOP;
                    else count <= count + 1'b1;
                end
                S_STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= data;
                        done <= 1'b1;
                        count <= 3'd0;
                        state <= S_IDLE;
                    end else begin
                        // Wait for stop bit
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end
endmodule
