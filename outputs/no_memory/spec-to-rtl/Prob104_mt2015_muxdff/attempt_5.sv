module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);
    logic d_in;
    logic q_internal;

    always @(*) begin
        // Multiplexer: if L is high, load q_in; else, load r_in
        d_in = L ? q_in : r_in;
    end

    always @(posedge clk) begin
        q_internal <= d_in;
    end

    assign Q = q_internal;

endmodule