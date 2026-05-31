module TopModule (
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    logic next_state;

    // Based on the simulation data:
    // q = a ^ b ^ state
    // next_state = (a & b) | (~(a ^ b) & state)
    // Actually, looking at the data:
    // state 0->1 happens when a=0, b=0 (t=75, t=135)
    // state 1->0 happens when a=1, b=1 (t=85) or a=0, b=0 (t=145)
    // This looks like next_state = (a ^ b) ? state : (~state)
    
    always @(*) begin
        q = a ^ b ^ state;
        next_state = (a ^ b) ? state : ~state;
    end

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule