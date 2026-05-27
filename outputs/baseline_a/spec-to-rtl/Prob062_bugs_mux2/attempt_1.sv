module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // The bug in the original code was that 'out' was defined as a 1-bit signal
    // instead of an 8-bit signal, which would truncate the result.
    // Also, the logic structure should be correctly assigned.

    logic [7:0] out_internal;

    always @(*) begin
        if (sel) begin
            out_internal = b;
        end else begin
            out_internal = a;
        end
    end

    assign out = out_internal;

endmodule
