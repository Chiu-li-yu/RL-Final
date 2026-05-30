module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output logic Q
);

    always_ff @(posedge clk) begin
        Q <= L ? r_in : q_in;
    end

endmodule