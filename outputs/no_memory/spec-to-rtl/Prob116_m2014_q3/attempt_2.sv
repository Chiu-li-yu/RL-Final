module TopModule (
    input [3:0] x,
    output f
);
    // Mapping:
    // Row bits: x[3], x[2]
    // Col bits: x[1], x[0]
    
    // Truth table based on provided K-map (d as 0 or 1):
    // R C | F
    // 00 00 | 0 (d->0)
    // 00 01 | 0
    // 00 11 | 0 (d->0)
    // 00 10 | 0 (d->0)
    // 01 00 | 0
    // 01 01 | 1 (d->1)
    // 01 11 | 1
    // 01 10 | 0
    // 11 00 | 1
    // 11 01 | 1
    // 11 11 | 0 (d->0)
    // 11 10 | 0 (d->0)
    // 10 00 | 1
    // 10 01 | 1
    // 10 11 | 0
    // 10 10 | 0 (d->0)
    
    // Boolean logic based on the above table:
    // F is 1 when:
    // (01, 01) -> x[3]=0, x[2]=1, x[1]=0, x[0]=1
    // (01, 11) -> x[3]=0, x[2]=1, x[1]=1, x[0]=1
    // (11, 00) -> x[3]=1, x[2]=1, x[1]=0, x[0]=0
    // (11, 01) -> x[3]=1, x[2]=1, x[1]=0, x[0]=1
    // (10, 00) -> x[3]=1, x[2]=0, x[1]=0, x[0]=0
    // (10, 01) -> x[3]=1, x[2]=0, x[1]=0, x[0]=1
    
    // Simplification:
    // F = (~x[3] & x[2] & x[0]) | (x[3] & ~x[1] & ~x[0]) | (x[3] & x[2] & ~x[1] & ~x[0])
    // Actually, looking at the patterns:
    // If x[3] == 0: F = x[2] & x[0]
    // If x[3] == 1: F = ~x[1] & ~x[0]
    
    assign f = (~x[3] & x[2] & x[0]) | (x[3] & ~x[1] & ~x[0]);

endmodule
