module TopModule (
    input logic clk,
    input logic reset,
    input logic [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    typedef enum logic [1:0] {
        S_WAIT = 2'd0,
        S_BYTE2 = 2'd1,
        S_BYTE3 = 2'd2
    } state_t;

    state_t state, next_state;
    logic [7:0] r1, r2, r3;
    logic done_r;

    always @(*) begin
        next_state = state;
        done_r = 1'b0;
        case (state)
            S_WAIT: if (in[3]) next_state = S_BYTE2;
            S_BYTE2: next_state = S_BYTE3;
            S_BYTE3: begin
                done_r = 1'b1;
                if (in[3]) next_state = S_BYTE2;
                else next_state = S_WAIT;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_WAIT;
            r1 <= 8'b0;
            r2 <= 8'b0;
            r3 <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= done_r;
            if (state == S_WAIT && in[3]) r1 <= in;
            if (state == S_BYTE2) r2 <= in;
            if (state == S_BYTE3) r3 <= in;
        end
    end

    assign out_bytes = {r1, r2, r3};

endmodule
