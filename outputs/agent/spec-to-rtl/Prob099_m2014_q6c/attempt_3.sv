module TopModule (
    input [5:0] y,
    input w,
    output logic Y2,
    output logic Y4
);

    always @(*) begin
        // State assignments (One-Hot):
        // y[0]: A (000001)
        // y[1]: B (000010)
        // y[2]: C (000100)
        // y[3]: D (001000)
        // y[4]: E (010000)
        // y[5]: F (100000)

        // Y2 is the next state of y[1] (State B)
        // Transition into B: A --0--> B
        Y2 = y[0] & ~w;

        // Y4 is the next state of y[3] (State D)
        // Transitions into D: B --1--> D, C --1--> D, E --1--> D, F --1--> D
        Y4 = w & (y[1] | y[2] | y[4] | y[5]);
    end

endmodule
