module TopModule (
    input logic clk,
    input logic in,
    output logic out
);

    logic q;
    logic next_q;

    // D flip-flop
    always_ff @(posedge clk) begin
        q <= next_q;
    end

    // Combinational logic (XOR)
    always_comb begin
        next_q = in ^ q;
    end

    // Output assignment
    assign out = q;

endmodule