
module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    logic [9:0] ns;
    logic o1, o2;

    always @(*) begin
        ns = 10'b0;
        
        // Transition from S0
        if (state[0]) begin
            if (in == 1'b0) ns[0] = 1'b1;
            else            ns[1] = 1'b1;
        end
        
        // Transition from S1
        if (state[1]) begin
            if (in == 1'b0) ns[0] = 1'b1;
            else            ns[2] = 1'b1;
        end
        
        // Transition from S2
        if (state[2]) begin
            if (in == 1'b0) ns[0] = 1'b1;
            else            ns[3] = 1'b1;
        end
        
        // Transition from S3
        if (state[3]) begin
            if (in == 1'b0) ns[0] = 1'b1;
            else            ns[4] = 1'b1;
        end
        
        // Transition from S4
        if (state[4]) begin
            if (in == 1'b0) ns[0] = 1'b1;
            else            ns[5] = 1'b1;
        end
        
        // Transition from S5
        if (state[5]) begin
            if (in == 1'b0) ns[8] = 1'b1;
            else            ns[6] = 1'b1;
        end
        
        // Transition from S6
        if (state[6]) begin
            if (in == 1'b0) ns[9] = 1'b1;
            else            ns[7] = 1'b1;
        end
        
        // Transition from S7
        if (state[7]) begin
            if (in == 1'b0) ns[0] = 1'b1;
            else            ns[7] = 1'b1;
        end
        
        // Transition from S8
        if (state[8]) begin
            if (in == 1'b0) ns[0] = 1'b1;
            else            ns[1] = 1'b1;
        end
        
        // Transition from S9
        if (state[9]) begin
            if (in == 1'b0) ns[0] = 1'b1;
            else            ns[1] = 1'b1;
        end
    end

    always @(*) begin
        o1 = state[8] | state[9];
        o2 = state[7] | state[9];
    end

    assign next_state = ns;
    assign out1 = o1;
    assign out2 = o2;

endmodule
