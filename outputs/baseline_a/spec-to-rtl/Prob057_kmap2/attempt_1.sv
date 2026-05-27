module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);

    // Karnaugh map analysis:
    //    cd \ ab | 00 | 01 | 11 | 10
    //    --------|----|----|----|----
    //    00      |  1 |  1 |  0 |  1
    //    01      |  1 |  0 |  0 |  1
    //    11      |  0 |  1 |  1 |  1
    //    10      |  1 |  1 |  0 |  0

    // Minterms (where output is 1):
    // (a=0,b=0,c=0,d=0) = ~a~b~c~d
    // (a=0,b=1,c=0,d=0) = ~ab~c~d
    // (a=1,b=0,c=0,d=0) = a~b~c~d
    // (a=0,b=0,c=0,d=1) = ~a~b~cd
    // (a=1,b=0,c=0,d=1) = a~b~cd
    // (a=1,b=1,c=1,d=1) = abcd
    // (a=0,b=1,c=1,d=1) = ~abcd
    // (a=1,b=0,c=1,d=1) = a~bcd
    // (a=0,b=0,c=1,d=0) = ~a~bc~d
    // (a=0,b=1,c=1,d=0) = ~abc~d
    // (a=1,b=1,c=1,d=0) = abc~d

    always @(*) begin
        out = (~a & ~b & ~c & ~d) | 
              (~a & b & ~c & ~d) | 
              (a & ~b & ~c & ~d) | 
              (~a & ~b & ~c & d) | 
              (a & ~b & ~c & d) | 
              (a & b & c & d) | 
              (~a & b & c & d) | 
              (a & ~b & c & d) | 
              (~a & ~b & c & ~d) | 
              (~a & b & c & ~d) | 
              (a & b & c & ~d);
    end
endmodule
