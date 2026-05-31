module TopModule(
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    localparam [3:0] IDLE = 4'd0,
                     S1   = 4'd1,
                     S2   = 4'd2,
                     S3   = 4'd3,
                     S4   = 4'd4,
                     S5   = 4'd5,
                     S5_0 = 4'd6,
                     S6   = 4'd7,
                     S7   = 4'd8;

    logic [3:0] state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: next_state = in ? S1 : IDLE;
            S1:   next_state = in ? S2 : IDLE;
            S2:   next_state = in ? S3 : IDLE;
            S3:   next_state = in ? S4 : IDLE;
            S4:   next_state = in ? S5 : IDLE;
            S5:   next_state = in ? S6 : S5_0;
            S5_0: next_state = in ? S1 : IDLE;
            S6:   next_state = in ? S7 : IDLE;
            S7:   next_state = in ? S7 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        disc = (state == S5_0);
        flag = (state == S6);
        err  = (state == S7);
    end

endmodule
