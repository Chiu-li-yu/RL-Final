module TopModule (
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);
    // Observe:
    // time 15: clk=1, a=0, b=0, state=0, q=0
    // time 45: clk=1, a=0, b=1, state=0, q=1
    // time 65: clk=1, a=1, b=1, state=0, q=0
    // time 75: clk=1, a=0, b=0, state=1, q=1
    //
    // Maybe:
    // next_state = (a & b)
    // q = state ^ a ^ b

    logic next_state;

    always_ff @(posedge clk) begin
        state <= next_state;
    end

    always @(*) begin
        next_state = a & b;
        q = state ^ a ^ b;
    end

endmodule
