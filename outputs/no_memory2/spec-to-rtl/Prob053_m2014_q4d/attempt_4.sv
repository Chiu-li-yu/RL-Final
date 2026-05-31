module TopModule (
    input logic clk,
    input logic in,
    output logic out
);

    logic d_in;
    logic q_out;

    always @(*) begin
        d_in = in ^ q_out;
    end

    always_ff @(posedge clk) begin
        q_out <= d_in;
    end

    assign out = q_out;

endmodule