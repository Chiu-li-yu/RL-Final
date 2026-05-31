module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output logic Q
);

    logic d;

    always @(*) begin
        if (L)
            d = r_in;
        else
            d = q_in;
    end

    always @(posedge clk) begin
        Q <= d;
    end

endmodule