module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    logic [1:0] state;
    logic [1:0] count;
    logic done_q;

    localparam SEARCH = 2'b00;
    localparam BYTE2  = 2'b01;
    localparam BYTE3  = 2'b10;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            count <= 2'b0;
            done_q <= 1'b0;
        end else begin
            case (state)
                SEARCH: begin
                    if (in[3]) begin
                        state <= BYTE2;
                        count <= 2'd1;
                        done_q <= 1'b0;
                    end else begin
                        state <= SEARCH;
                        done_q <= 1'b0;
                    end
                end
                BYTE2: begin
                    state <= BYTE3;
                    count <= 2'd2;
                    done_q <= 1'b0;
                end
                BYTE3: begin
                    state <= SEARCH;
                    count <= 2'd3;
                    done_q <= 1'b1;
                end
                default: begin
                    state <= SEARCH;
                    done_q <= 1'b0;
                end
            endcase
        end
    end

    assign done = done_q;

endmodule
