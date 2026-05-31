module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    parameter [3:0] S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6_DISC = 6, S6_FLAG = 7, S7_ERR = 8;
    logic [3:0] current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            // When in S5:
            // 011111 + 0 = S6_DISC
            // 011111 + 1 = S6_FLAG (0111111) -> Wait, 0111111 is 6 ones. 
            // 0111111 + 0 = Flag (01111110)
            // 0111111 + 1 = Err (01111111)
            S5: next_state = in ? 9 : S6_DISC; // Add S6_WAIT_FLAG
            9:  next_state = in ? S7_ERR : S6_FLAG;
            S6_DISC: next_state = in ? S1 : S0;
            S6_FLAG: next_state = in ? S1 : S0;
            S7_ERR: next_state = in ? S7_ERR : S0;
            default: next_state = S0;
        endcase
    end

    assign disc = (current_state == S6_DISC);
    assign flag = (current_state == S6_FLAG);
    assign err  = (current_state == S7_ERR);

endmodule
