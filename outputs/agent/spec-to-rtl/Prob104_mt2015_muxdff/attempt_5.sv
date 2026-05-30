module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output logic Q
);

    logic d;
    assign d = L ? r_in : q_in;

    always_ff @(posedge clk) begin
        Q <= d;
    end

endmodule