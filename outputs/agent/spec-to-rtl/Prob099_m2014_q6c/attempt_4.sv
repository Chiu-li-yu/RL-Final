module TopModule (
    input [5:0] y,
    input w,
    output logic Y1,
    output logic Y3
);

    always @(*) begin
        // State assignments (One-Hot):
        // y[0]: A, y[1]: B, y[2]: C, y[3]: D, y[4]: E, y[5]: F
        
        // Y1 corresponds to the next state of y[1] (State B)
        // Transition into B: A --0--> B
        Y1 = y[0] & ~w;
        
        // Y3 corresponds to the next state of y[3] (State D)
        // Transitions into D: B --1--> D, C --1--> D, E --1--> D, F --1--> D
        Y3 = w & (y[1] | y[2] | y[4] | y[5]);
    end

endmodule
