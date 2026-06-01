module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    localparam S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5, S6 = 4'd6, S7 = 4'd7, S_ERR = 4'd8;
    logic [3:0] state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            // Reset output signals at every clock cycle
            disc <= 1'b0;
            flag <= 1'b0;
            
            case (state)
                S0: state <= (in) ? S1 : S0;
                S1: state <= (in) ? S2 : S0;
                S2: state <= (in) ? S3 : S0;
                S3: state <= (in) ? S4 : S0;
                S4: state <= (in) ? S5 : S0;
                S5: begin
                    if (in) state <= S6;
                    else begin
                        state <= S0;
                        disc <= 1'b1;
                    end
                end
                S6: begin
                    if (in) state <= S7;
                    else begin
                        state <= S0;
                        flag <= 1'b1;
                    end
                end
                S7: begin
                    if (in) begin
                        state <= S_ERR;
                        err <= 1'b1;
                    end else state <= S0;
                end
                S_ERR: begin
                    state <= S_ERR;
                    err <= 1'b1;
                end
            endcase
        end
    end

endmodule