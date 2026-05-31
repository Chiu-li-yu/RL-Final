module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    // State encoding:
    // A: y[0]=1 (000001)
    // B: y[1]=1 (000010)
    // C: y[2]=1 (000100)
    // D: y[3]=1 (001000)
    // E: y[4]=1 (010000)
    // F: y[5]=1 (100000)

    // Next State Logic:
    // A --0--> B
    // A --1--> A
    // B --0--> C
    // B --1--> D
    // C --0--> E
    // C --1--> D
    // D --0--> F
    // D --1--> A
    // E --0--> E
    // E --1--> D
    // F --0--> C
    // F --1--> D

    // Next state Y1 (State B):
    // Transition to B: A(y[0]=1) and w=0
    // Y1 = y[0] & ~w

    // Next state Y3 (State D):
    // Transition to D: B(y[1]=1) & w=1, C(y[2]=1) & w=1, E(y[4]=1) & w=1, F(y[5]=1) & w=1
    // Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w)
    // Y3 = w & (y[1] | y[2] | y[4] | y[5])

    always @(*) begin
        Y1 = y[0] & ~w;
        Y3 = w & (y[1] | y[2] | y[4] | y[5]);
    end
endmodule