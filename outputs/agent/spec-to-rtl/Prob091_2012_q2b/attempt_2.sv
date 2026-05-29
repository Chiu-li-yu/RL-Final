module TopModule (
    input [5:0] y,
    input w,
    output logic Y1,
    output logic Y3
);

    always @(*) begin
        // One-hot encoding:
        // y[0] = A, y[1] = B, y[2] = C, y[3] = D, y[4] = E, y[5] = F
        
        // Y1 is the next state of y[1] (State B)
        // Transition to B: A --1--> B
        Y1 = y[0] & w;
        
        // Y3 is the next state of y[3] (State D)
        // Transitions to D: B --0--> D, C --0--> D, E --0--> D, F --0--> D
        Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;
    end

endmodule
