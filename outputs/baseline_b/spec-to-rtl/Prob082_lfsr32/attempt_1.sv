module TopModule (
    input logic clk,
    input logic reset,
    output logic [31:0] q
);

    // Galois LFSR with taps at 32, 22, 2, 1
    // The bits are 0-indexed: q[31], q[30], ..., q[0]
    // Taps correspond to positions (in 1-based index) 32, 22, 2, 1
    // This maps to 0-based index: 31, 21, 1, 0
    //
    // Galois LFSR shift logic:
    // next_q[31] = (0 ^ q[0]) = q[0]
    // next_q[30] = q[31]
    // ...
    // next_q[22] = q[23] ^ q[0] (since tap at 22, index 21)
    // ...
    // next_q[2]  = q[3] ^ q[0] (since tap at 2, index 1)
    // next_q[1]  = q[2] ^ q[0] (since tap at 1, index 0)
    // next_q[0]  = q[1]

    logic [31:0] next_q;

    always @(*) begin
        next_q[31] = q[0];
        next_q[30:22] = q[31:23];
        next_q[21] = q[22] ^ q[0];
        next_q[20:2] = q[21:3];
        next_q[1] = q[2] ^ q[0];
        next_q[0] = q[1] ^ q[0];
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

endmodule
