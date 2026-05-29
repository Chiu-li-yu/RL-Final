module TopModule (
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // State assignments (one-hot):
    // A: y[0] = 1
    // B: y[1] = 1
    // C: y[2] = 1
    // D: y[3] = 1
    // E: y[4] = 1
    // F: y[5] = 1

    // Y1 is the input to state flip-flop y[1] (Next state B)
    // Transition to B:
    // A --1--> B
    logic y1_next;
    always @(*) begin
        y1_next = (y[0] && w);
    end

    // Y3 is the input to state flip-flop y[3] (Next state D)
    // Transitions to D:
    // B --0--> D
    // C --0--> D
    // E --0--> D
    // F --0--> D
    logic y3_next;
    always @(*) begin
        y3_next = (y[1] && !w) || (y[2] && !w) || (y[4] && !w) || (y[5] && !w);
    end

    assign Y1 = y1_next;
    assign Y3 = y3_next;

endmodule
