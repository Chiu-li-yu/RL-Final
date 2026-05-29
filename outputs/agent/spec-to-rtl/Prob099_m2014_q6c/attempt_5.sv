module TopModule (
    input [5:0] y,
    input w,
    output logic Y2,
    output logic Y4
);

    always @(*) begin
        // State assignments:
        // y[0]: A, y[1]: B, y[2]: C, y[3]: D, y[4]: E, y[5]: F
        
        // Y2 is the next state of y[1] (State B)
        // Transition into B: A --0--> B
        Y2 = y[0] & ~w;
        
        // Y4 is the next state of y[3] (State D)
        // Transitions into D: B --1--> D, C --1--> D, E --1--> D, F --1--> D
        Y4 = w & (y[1] | y[2] | y[4] | y[5]);
    end

endmodule
