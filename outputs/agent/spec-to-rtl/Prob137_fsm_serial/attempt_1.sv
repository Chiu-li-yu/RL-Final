
module TopModule (
    input  clk,
    input  reset,
    input  in,
    output done
);

    localparam S_IDLE      = 2'd0;
    localparam S_DATA      = 2'd1;
    localparam S_STOP      = 2'd2;
    localparam S_WAIT_STOP = 2'd3;

    logic [1:0] state;
    logic [2:0] count;
    logic done_reg;

    assign done = done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            count <= 3'd0;
            done_reg <= 1'b0;
        end else begin
            done_reg <= 1'b0; // Default: pulse for one cycle
            case (state)
                S_IDLE: begin
                    if (in == 1'b0) begin
                        state <= S_DATA;
                        count <= 3'd0;
                    end else begin
                        state <= S_IDLE;
                    end
                end
                
                S_DATA: begin
                    if (count == 3'd7) begin
                        state <= S_STOP;
                    end else begin
                        count <= count + 3'd1;
                        state <= S_DATA;
                    end
                end
                
                S_STOP: begin
                    if (in == 1'b1) begin
                        done_reg <= 1'b1;
                        state <= S_IDLE;
                    end else begin
                        state <= S_WAIT_STOP;
                    end
                end
                
                S_WAIT_STOP: begin
                    if (in == 1'b1) begin
                        state <= S_IDLE;
                    end else begin
                        state <= S_WAIT_STOP;
                    end
                end
                
                default: state <= S_IDLE;
            endcase
        end
    end

endmodule
