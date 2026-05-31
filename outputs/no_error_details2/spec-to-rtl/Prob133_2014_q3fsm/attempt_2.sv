module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);

    // States:
    // A: Waiting for s=1
    // B1: Cycle 1
    // B2: Cycle 2
    // B3: Cycle 3
    // DONE: State to output Z high

    localparam S_A = 3'd0;
    localparam S_B1 = 3'd1;
    localparam S_B2 = 3'd2;
    localparam S_B3 = 3'd3;
    localparam S_Z  = 3'd4;

    logic [2:0] state, next_state;
    logic [1:0] w_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_A;
            w_count <= 2'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            
            // Logic for w_count
            if (state == S_A && s) w_count <= (w ? 1 : 0);
            else if (state == S_B1) w_count <= w_count + (w ? 1 : 0);
            else if (state == S_B2) w_count <= w_count + (w ? 1 : 0);
            else w_count <= 0;

            // Logic for z
            if (state == S_B2 && (w_count + w == 2)) z <= 1'b1;
            else z <= 1'b0;
        end
    end

    always @(*) begin
        case (state)
            S_A: next_state = (s) ? S_B1 : S_A;
            S_B1: next_state = S_B2;
            S_B2: next_state = S_B3;
            S_B3: next_state = S_B1;
            default: next_state = S_A;
        endcase
    end
endmodule
