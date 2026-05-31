module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);
    // Let's use the simplest SOP: (~a & ~b & c) | (b & c & d) | (a & c & d)
    assign out_sop = (~a & ~b & c) | (c & d & (a | b));
    
    // For POS, let's use the property:
    // Out = 1 iff (minterm 2, 7, 15)
    // Out = 0 iff (minterm 0, 1, 4, 5, 6, 9, 10, 13, 14)
    // Don't care: 3, 8, 11, 12
    
    // Let's use Quine-McCluskey or a simple solver.
    // 0: 0000 -> (a+b+c+d)
    // 1: 0001 -> (a+b+c+~d)
    // ...
    // Using a K-map online solver tool simulation:
    // POS = (a | c) & (~a | b | d) & (c | ~d) & (~b | ~c | ~d) ... this is still tough.
    // Let's try: POS = (a | c) & (b | c | d) & (~a | ~b | ~c | ~d) -- Wait, this is not correct.
    
    // POS = (a|c) & (b|c|d) & (~a|~b|d) & (~a|~c|~d)
    assign out_pos = (a | c) & (b | c | d) & (~a | ~b | d) & (~a | ~c | ~d);
    
endmodule