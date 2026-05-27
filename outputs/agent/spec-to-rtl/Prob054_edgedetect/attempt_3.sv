module TopModule(
    input logic clk,
    input logic [7:0] in,
    output logic [7:0] pedge
);
    logic [7:0] prev_in;
    logic [7:0] next_pedge;

    always_ff @(posedge clk) begin
        prev_in <= in;
        pedge <= next_pedge;
    end

    always_comb begin
        next_pedge = (~prev_in & in);
    end

endmodule