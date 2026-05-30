module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output logic Q
);

    logic d;

    // 2:1 multiplexer logic
    always @(*) begin
        if (L) begin
            d = r_in;
        end else begin
            d = q_in;
        end
    end

    // D Flip-Flop
    always @(posedge clk) begin
        Q <= d;
    end

endmodule