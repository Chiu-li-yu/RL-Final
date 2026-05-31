module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0]    sel,
    output logic [3:0]    out
);

    // sel is 8 bits (0-255), total 256 possibilities.
    // Each selection is 4 bits wide.
    // Indexing:
    // sel = 0 -> in[3:0]
    // sel = 1 -> in[7:4]
    // ...
    // sel = k -> in[4*k + 3 : 4*k]
    
    always @(*) begin
        out = in[sel * 4 + 3 : sel * 4];
    end

endmodule
