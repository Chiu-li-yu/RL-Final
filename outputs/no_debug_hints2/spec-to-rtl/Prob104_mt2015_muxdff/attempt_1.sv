module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);
    logic q_reg;
    logic next_q;

    assign Q = q_reg;
    always @(*) begin
        if (L)
            next_q = r_in;
        else
            next_q = q_in;
    end

    always @(posedge clk) begin
        q_reg <= next_q;
    end
endmodule

// Helper to verify the design (not part of the final TopModule output)
module full_module_tb;
    logic clk, L;
    logic [2:0] r;
    wire [2:0] q;

    // Logic based on original code
    // q_next[2] = q[1] ^ q[2]
    // q_next[1] = q[0]
    // q_next[0] = q[2]
    
    TopModule tm2 (.clk(clk), .L(L), .q_in(q[1] ^ q[2]), .r_in(r[2]), .Q(q[2]));
    TopModule tm1 (.clk(clk), .L(L), .q_in(q[0]),        .r_in(r[1]), .Q(q[1]));
    TopModule tm0 (.clk(clk), .L(L), .q_in(q[2]),        .r_in(r[0]), .Q(q[0]));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
endmodule
