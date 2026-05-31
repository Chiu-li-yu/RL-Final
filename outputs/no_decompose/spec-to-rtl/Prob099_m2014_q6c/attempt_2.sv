module TopModule (
    input [5:0] y,
    input w,
    output logic Y1,
    output logic Y3
);
    // State encoding:
    // A: y[0]=1 (000001)
    // B: y[1]=1 (000010)
    // C: y[2]=1 (000100)
    // D: y[3]=1 (001000)
    // E: y[4]=1 (010000)
    // F: y[5]=1 (100000)

    // Transitions:
    // A -> B (if w=0)
    // A -> A (if w=1)
    // B -> C (if w=0)
    // B -> D (if w=1)
    // C -> E (if w=0)
    // C -> D (if w=1)
    // D -> F (if w=0)
    // D -> A (if w=1)
    // E -> E (if w=0)
    // E -> D (if w=1)
    // F -> C (if w=0)
    // F -> D (if w=1)

    // Next State Logic:
    // B = (y[0] & ~w)
    // D = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w)

    always @(*) begin
        Y1 = (y[0] & ~w);
        Y3 = (y[1] | y[2] | y[4] | y[5]) & w;
    end
endmodule