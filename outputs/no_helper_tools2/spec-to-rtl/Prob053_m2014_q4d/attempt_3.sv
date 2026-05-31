module TopModule (
    input logic clk,
    input logic in,
    output logic out
);
    logic q;

    // Use initial to set initial state to 0 for simulation, 
    // although real hardware may need async reset.
    // However, the problem says no reset.
    // Let's check if the logic is correct.
    // XOR gate: q_next = in ^ q
    
    always_ff @(posedge clk) begin
        q <= in ^ q;
    end

    assign out = q;

    initial begin
        q = 1'b0;
    end
endmodule
