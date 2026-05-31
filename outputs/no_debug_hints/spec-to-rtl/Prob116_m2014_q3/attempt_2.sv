module TopModule (
    input [3:0] x,
    output f
);
    // Re-evaluating K-map with bits x[3], x[2], x[1], x[0]
    // x[3], x[2] are rows, x[1], x[0] are columns.
    // 0000: d->0
    // 0001: 0
    // 0011: d->0
    // 0010: d->0
    // 0100: 0
    // 0101: d->1
    // 0111: 1
    // 0110: 0
    // 1100: 1
    // 1101: 1
    // 1111: d->1
    // 1110: d->1
    // 1000: 1
    // 1001: 1
    // 1011: 0
    // 1010: d->0

    // Logic for f(x3,x2,x1,x0):
    // Sum of minterms: 6, 8, 9, 10, 11, 12, 13 (with 5, 10, 11, 15 as d)
    // Simplified f = x[3] | (x[2] & x[1])
    assign f = x[3] | (x[2] & x[1]);
endmodule
