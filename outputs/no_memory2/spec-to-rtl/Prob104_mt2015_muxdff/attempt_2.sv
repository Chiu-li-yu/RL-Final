module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output logic Q
);
    logic next_q;
    
    // Mux logic: L selects r_in, otherwise q_in (the result of the feedback/shift function)
    assign next_q = L ? r_in : q_in;

    // Flip-flop
    always @(posedge clk) begin
        Q <= next_q;
    end
endmodule

// Helper to verify the design logic (Full Module)
module TopModule_Test (
    input clk,
    input L,
    input [2:0] r,
    output [2:0] q
);
    logic [2:0] next_q_in;
    
    // Feedback logic based on full_module requirement
    // q[2] <= q[1] ^ q[2]
    // q[1] <= q[0]
    // q[0] <= q[2]
    assign next_q_in[2] = q[1] ^ q[2];
    assign next_q_in[1] = q[0];
    assign next_q_in[0] = q[2];

    TopModule stage0 (.clk(clk), .L(L), .q_in(next_q_in[0]), .r_in(r[0]), .Q(q[0]));
    TopModule stage1 (.clk(clk), .L(L), .q_in(next_q_in[1]), .r_in(r[1]), .Q(q[1]));
    TopModule stage2 (.clk(clk), .L(L), .q_in(next_q_in[2]), .r_in(r[2]), .Q(q[2]));
endmodule
