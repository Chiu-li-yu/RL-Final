module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);
    typedef enum logic [2:0] {
        A = 3'd0,
        B0 = 3'd1,
        B1 = 3'd2,
        B2 = 3'd3,
        CHECK = 3'd4
    } state_t;

    state_t state, next_state;
    logic [1:0] w_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'b0;
        end else begin
            state <= next_state;
            if (state == A) begin
                w_count <= 2'b0;
            end else if (state == B0 || state == B1 || state == B2) begin
                w_count <= w_count + w;
            end else begin
                w_count <= 2'b0;
            end
        end
    end

    always @(*) begin
        case (state)
            A: next_state = s ? B0 : A;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = CHECK;
            CHECK: next_state = B0;
            default: next_state = A;
        endcase
    end

    always @(*) begin
        if (state == CHECK && w_count == 2'd2)
            z = 1'b1;
        else
            z = 1'b0;
    end
endmodule
