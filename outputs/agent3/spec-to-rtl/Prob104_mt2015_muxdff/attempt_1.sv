module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    logic q_internal;
    logic d_next;

    // 2:1 Multiplexer logic
    always @(*) begin
        if (L) begin
            d_next = r_in;
        end else begin
            d_next = q_in;
        end
    end

    // Flip-flop
    always_ff @(posedge clk) begin
        q_internal <= d_next;
    end

    assign Q = q_internal;

endmodule
