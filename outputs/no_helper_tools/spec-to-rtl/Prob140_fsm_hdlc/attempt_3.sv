module TopModule (
    input logic clk,
    input logic reset,
    input logic in,
    output logic disc,
    output logic flag,
    output logic err
);

    logic [3:0] state, next_state;

    localparam S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S_DISC = 7, S_FLAG = 8, S_ERR = 9;

    always_ff @(posedge clk) begin
        if (reset) state <= S0;
        else state <= next_state;
    end

    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S_DISC;
            S6: next_state = in ? S_ERR : S_FLAG;
            S_DISC: next_state = in ? S1 : S0;
            S_FLAG: next_state = in ? S1 : S0;
            S_ERR: next_state = in ? S_ERR : S0;
            default: next_state = S0;
        endcase
    end

    assign disc = (state == S_DISC);
    assign flag = (state == S_FLAG);
    assign err  = (state == S_ERR);

endmodule
