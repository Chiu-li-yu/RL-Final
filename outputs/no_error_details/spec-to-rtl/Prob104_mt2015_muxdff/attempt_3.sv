module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output logic Q
);

    logic next_q;

    always @(*) begin
        if (L) begin
            next_q = r_in;
        end else begin
            next_q = q_in;
        end
    end

    always @(posedge clk) begin
        Q <= next_q;
    end

endmodule