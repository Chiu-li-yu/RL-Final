module TopModule (
    input clk,
    input reset,
    input w,
    output logic z
);

    typedef enum logic [2:0] {
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5
    } state_t;

    logic [2:0] current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= 3'd0; // A
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            3'd0: next_state = (w) ? 3'd0 : 3'd1; // A->A, A->B
            3'd1: next_state = (w) ? 3'd3 : 3'd2; // B->D, B->C
            3'd2: next_state = (w) ? 3'd3 : 3'd4; // C->D, C->E
            3'd3: next_state = (w) ? 3'd0 : 3'd5; // D->A, D->F
            3'd4: next_state = (w) ? 3'd3 : 3'd4; // E->D, E->E
            3'd5: next_state = (w) ? 3'd3 : 3'd2; // F->D, F->C
            default: next_state = 3'd0;
        endcase
    end

    always @(*) begin
        case (current_state)
            3'd4, 3'd5: z = 1'b1; // E, F
            default: z = 1'b0;
        endcase
    end

endmodule
