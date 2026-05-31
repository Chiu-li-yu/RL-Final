module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output logic Q
);

    logic q_val;
    assign Q = q_val;

    always_ff @(posedge clk) begin
        if (L)
            q_val <= r_in;
        else
            q_val <= q_in;
    end

endmodule
