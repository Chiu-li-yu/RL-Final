module TopModule (
    input logic clk,
    input logic reset,
    output logic [31:0] q
);

    // Galois LFSR with taps at 32, 22, 2, and 1.
    // Positions are 1-based index in spec, usually map to 0-based index:
    // Tap 32 -> bit 31
    // Tap 22 -> bit 21
    // Tap 2  -> bit 1
    // Tap 1  -> bit 0
    //
    // The LSB output bit is q[0].
    // Shift right logic:
    // new_q[31] = (0 ^ q[0]) = q[0] if tap 32
    // new_q[30:22] = q[31:23]
    // new_q[21] = (q[22] ^ q[0]) if tap 22
    // new_q[20:2] = q[21:3]
    // new_q[1] = (q[2] ^ q[0]) if tap 2
    // new_q[0] = (q[1] ^ q[0]) if tap 1

    logic [31:0] next_q;

    always @(*) begin
        next_q[31]    = q[0];
        next_q[30:22] = q[31:23];
        next_q[21]    = q[22] ^ q[0];
        next_q[20:2]  = q[21:3];
        next_q[1]     = q[2] ^ q[0];
        next_q[0]     = q[1] ^ q[0];
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

endmodule
