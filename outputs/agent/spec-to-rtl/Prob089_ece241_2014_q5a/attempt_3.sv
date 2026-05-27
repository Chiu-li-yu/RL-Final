module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);

    typedef enum logic {
        S_WAIT = 1'b0,
        S_INVERT = 1'b1
    } state_t;

    state_t state;

    // The logic for serial 2's complement:
    // 1. Output the incoming bit as is until the first '1' is encountered.
    // 2. Once the first '1' is encountered (inclusive), invert all subsequent bits.

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_WAIT;
        end else begin
            case (state)
                S_WAIT: if (x) state <= S_INVERT;
                S_INVERT: state <= S_INVERT;
            endcase
        end
    end

    // Combinational output logic
    always @(*) begin
        if (state == S_WAIT)
            z = x;
        else
            z = !x;
    end

endmodule
