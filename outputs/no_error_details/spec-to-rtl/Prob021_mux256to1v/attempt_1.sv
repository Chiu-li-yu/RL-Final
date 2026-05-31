module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0]    sel,
    output logic [3:0]    out
);
    // 256-to-1 multiplexer, each input is 4 bits wide.
    // Total 1024 bits: 256 * 4 = 1024.
    // If sel = 0, select in[3:0].
    // If sel = 1, select in[7:4].
    // General formula: in[(sel * 4) + 3 : (sel * 4)]

    always @(*) begin
        out = in[sel * 4 + 3 -: 4];
    end
endmodule