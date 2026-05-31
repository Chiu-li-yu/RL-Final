module TopModule (
    input in,
    input [3:0] state,
    output logic [3:0] next_state,
    output logic out
);

    // One-hot encoding definitions
    // A = 4'b0001 (state[0])
    // B = 4'b0010 (state[1])
    // C = 4'b0100 (state[2])
    // D = 4'b1000 (state[3])

    logic s0, s1, s2, s3;
    assign s0 = state[0];
    assign s1 = state[1];
    assign s2 = state[2];
    assign s3 = state[3];

    always @(*) begin
        // NS0 (A): (state A and in=0) or (state C and in=0)
        next_state[0] = (~in & s0) | (~in & s2);
        
        // NS1 (B): (state A and in=1) or (state B and in=1) or (state D and in=1)
        next_state[1] = (in & s0) | (in & s1) | (in & s3);
        
        // NS2 (C): (state B and in=0) or (state D and in=0)
        next_state[2] = (~in & s1) | (~in & s3);
        
        // NS3 (D): (state C and in=1)
        next_state[3] = (in & s2);
    end

    always @(*) begin
        // Output logic: Out = 1 only in state D
        out = s3;
    end

endmodule
