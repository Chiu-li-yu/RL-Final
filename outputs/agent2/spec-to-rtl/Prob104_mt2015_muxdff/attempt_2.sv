module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    logic q_internal;

    // Flip-flop logic with 2:1 multiplexer directly in FF logic
    // Q is output directly, or can be registered.
    // The requirement is to behave like the FF + MUX combination.
    // The previous implementation used d_next = L ? r_in : q_in;
    // which corresponds to the FF input.

    always_ff @(posedge clk) begin
        if (L)
            q_internal <= r_in;
        else
            q_internal <= q_in;
    end

    assign Q = q_internal;

endmodule
