module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);
    logic next_state;
    logic current_state;

    // Use a flip-flop to store the state
    always_ff @(posedge clk) begin
        current_state <= next_state;
    end

    // Next state logic: S+ = (a & b) | S
    always @(*) begin
        next_state = (a & b) | current_state;
    end

    // Output logic: q = a ^ b ^ S
    assign q = a ^ b ^ current_state;
    assign state = current_state;

endmodule