
module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    localparam S0 = 2'd0;
    localparam S1 = 2'd1;
    localparam S2 = 2'd2;
    localparam S3 = 2'd3;

    logic [1:0] state;
    logic [7:0] byte1, byte2, byte3;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            out_bytes <= 24'b0;
        end else begin
            case (state)
                S0: begin
                    if (in[3]) begin
                        byte1 <= in;
                        state <= S1;
                    end else begin
                        state <= S0;
                    end
                end
                S1: begin
                    byte2 <= in;
                    state <= S2;
                end
                S2: begin
                    byte3 <= in;
                    out_bytes <= {byte1, byte2, in};
                    state <= S3;
                end
                S3: begin
                    if (in[3]) begin
                        byte1 <= in;
                        state <= S1;
                    end else begin
                        state <= S0;
                    end
                end
                default: state <= S0;
            endcase
        end
    end

    assign done = (state == S3);

endmodule
