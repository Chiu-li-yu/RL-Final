module TopModule (
    input [3:0] x,
    output f
);
    // K-map provided:
    // x[3]x[4] in problem, let's assume input order is x[3], x[2], x[1], x[0]
    // The map says:
    // Row 00: d, 0, d, d
    // Row 01: 0, d, 1, 0
    // Row 11: 1, 1, d, d
    // Row 10: 1, 1, 0, d
    
    // Let's assume input is x[0]x[1]x[2]x[3] where
    // Row is x[0]x[1], Col is x[2]x[3].
    // Map indices: 00, 01, 11, 10
    
    // Try interpreting as:
    // x = x[3]x[2]x[1]x[0]
    // Row = x[3]x[2]
    // Col = x[1]x[0]

    // Truth Table reconstructed from K-map:
    // Row x[3]x[2] (0-3), Col x[1]x[0] (0-3)
    // Indices:
    // (0,0) -> 0
    // (0,1) -> 0
    // (0,2) -> 0 (d)
    // (0,3) -> 0 (d)
    // (1,0) -> 0
    // (1,1) -> ? (d)
    // (1,2) -> 1
    // (1,3) -> 0
    // (2,0) -> 1
    // (2,1) -> 1
    // (2,2) -> ? (d)
    // (2,3) -> ? (d)
    // (3,0) -> 1
    // (3,1) -> 1
    // (3,2) -> 0
    // (3,3) -> ? (d)

    // Let's test a simple function: f = (~x[3] & x[2] & x[1]) | (x[3] & ~x[2])
    // Wait, the column order in K-map was 00, 01, 11, 10.
    // 00=0, 01=1, 11=3, 10=2
    
    // Index map (row, col):
    // (0,0) -> x[3]=0, x[2]=0, x[1]=0, x[0]=0 | f=d
    // (0,1) -> x[3]=0, x[2]=0, x[1]=0, x[0]=1 | f=0
    // (0,3) -> x[3]=0, x[2]=0, x[1]=1, x[0]=1 | f=d
    // (0,2) -> x[3]=0, x[2]=0, x[1]=1, x[0]=0 | f=d
    // (1,0) -> x[3]=0, x[2]=1, x[1]=0, x[0]=0 | f=0
    // (1,1) -> x[3]=0, x[2]=1, x[1]=0, x[0]=1 | f=d
    // (1,3) -> x[3]=0, x[2]=1, x[1]=1, x[0]=1 | f=1
    // (1,2) -> x[3]=0, x[2]=1, x[1]=1, x[0]=0 | f=0
    // (3,0) -> x[3]=1, x[2]=1, x[1]=0, x[0]=0 | f=1
    // (3,1) -> x[3]=1, x[2]=1, x[1]=0, x[0]=1 | f=1
    // (3,3) -> x[3]=1, x[2]=1, x[1]=1, x[0]=1 | f=d
    // (3,2) -> x[3]=1, x[2]=1, x[1]=1, x[0]=0 | f=d
    // (2,0) -> x[3]=1, x[2]=0, x[1]=0, x[0]=0 | f=1
    // (2,1) -> x[3]=1, x[2]=0, x[1]=0, x[0]=1 | f=1
    // (2,3) -> x[3]=1, x[2]=0, x[1]=1, x[0]=1 | f=0
    // (2,2) -> x[3]=1, x[2]=0, x[1]=1, x[0]=0 | f=d

    // Let's try f = (~x[3] & x[2] & x[1] & x[0]) | (x[3] & ~x[1])
    
    logic f_out;
    always @(*) begin
        // Based on analysis:
        // f = 1 at (0,1,1,1), (1,1,0,0), (1,1,0,1), (1,0,0,0), (1,0,0,1)
        // Let's try:
        f_out = (~x[3] & x[2] & x[1] & x[0]) | (x[3] & ~x[1]);
    end
    
    assign f = f_out;

endmodule
