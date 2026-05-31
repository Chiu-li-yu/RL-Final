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
        S_BYTE3 = 2'd2,
        S_DONE = 2'd3
    } state_t;

    state_t state, next_state;
    logic [23:0] shift_reg;
    logic [7:0] b1, b2, b3;

    always @(*) begin
        next_state = state;
        case (state)
            S_WAIT: if (in[3]) next_state = S_BYTE2;
            S_BYTE2: next_state = S_BYTE3;
            S_BYTE3: next_state = S_DONE;
            S_DONE: if (in[3]) next_state = S_BYTE2;
                    else next_state = S_WAIT;
            default: next_state = S_WAIT;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_WAIT;
            b1 <= 8'b0;
            b2 <= 8'b0;
            b3 <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (state == S_WAIT && in[3]) b1 <= in;
            if (state == S_BYTE2) b2 <= in;
            if (state == S_BYTE3) b3 <= in;
            
            if (next_state == S_DONE) done <= 1'b1;
            else done <= 1'b0;
        end
    end

    assign out_bytes = {b1, b2, b3};

endmodule
