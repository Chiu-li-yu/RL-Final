module TopModule(
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    localparam S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5, SDISC = 4'd6, SFLAG = 4'd7, SERR = 4'd8;

    logic [3:0] state, next_state;

    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? SERR : SDISC;
            SDISC: next_state = in ? S1 : S0;
            SFLAG: next_state = in ? S1 : S0;
            SERR: next_state = in ? SERR : S0;
            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;
            disc <= (next_state == SDISC);
            flag <= (next_state == SFLAG);
            err <= (next_state == SERR);
        end
    end
endmodule
