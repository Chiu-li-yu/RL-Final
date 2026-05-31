module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output logic Q
);

    logic next_q;
    always_comb begin
        if (L)
            next_q = r_in;
        else
            next_q = q_in;
    end

    always_ff @(posedge clk) begin
        Q <= next_q;
    end

endmodule
