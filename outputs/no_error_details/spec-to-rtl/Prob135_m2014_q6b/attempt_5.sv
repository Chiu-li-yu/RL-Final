module TopModule(
    input [2:0] y,
    input w,
    output Y1
);
    // Y=000, w=0 -> Next=001, Y1=0
    // Y=000, w=1 -> Next=000, Y1=0
    // Y=001, w=0 -> Next=010, Y1=1
    // Y=001, w=1 -> Next=011, Y1=1
    // Y=010, w=0 -> Next=100, Y1=0
    // Y=010, w=1 -> Next=011, Y1=1
    // Y=011, w=0 -> Next=101, Y1=0
    // Y=011, w=1 -> Next=000, Y1=0
    // Y=100, w=0 -> Next=100, Y1=0
    // Y=100, w=1 -> Next=011, Y1=1
    // Y=101, w=0 -> Next=010, Y1=1
    // Y=101, w=1 -> Next=011, Y1=1
    
    // Y1 is the second bit (y[1]) of the next state.
    // The cases where Y1=1 are:
    // (y=001, w=0) -> 001_0
    // (y=001, w=1) -> 001_1
    // (y=010, w=1) -> 010_1
    // (y=100, w=1) -> 100_1
    // (y=101, w=0) -> 101_0
    // (y=101, w=1) -> 101_1
    
    assign Y1 = (y == 3'b001) | (y == 3'b010 & w) | (y == 3'b100 & w) | (y == 3'b101);
endmodule