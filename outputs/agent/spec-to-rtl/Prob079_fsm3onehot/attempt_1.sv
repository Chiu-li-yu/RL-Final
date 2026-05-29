module TopModule (
    input in,
    input [3:0] state,
    output logic [3:0] next_state,
    output logic out
);

    // State encoding
    // A = 4'b0001
    // B = 4'b0010
    // C = 4'b0100
    // D = 4'b1000

    always @(*) begin
        // State transition logic
        // next_state[0] (A): (state==A && in==0) || (state==C && in==0)
        next_state[0] = (state[0] & ~in) | (state[2] & ~in);
        
        // next_state[1] (B): (state==A && in==1) || (state==B && in==1) || (state==D && in==1)
        next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in);
        
        // next_state[2] (C): (state==B && in==0) || (state==D && in==0)
        next_state[2] = (state[1] & ~in) | (state[3] & ~in);
        
        // next_state[3] (D): (state==C && in==1)
        next_state[3] = (state[2] & in);

        // Output logic (Moore: depends only on current state)
        // out = 1 if state == D
        out = state[3];
    end

endmodule
