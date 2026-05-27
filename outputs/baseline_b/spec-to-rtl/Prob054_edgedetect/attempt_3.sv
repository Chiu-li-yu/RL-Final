module TopModule (
    input logic clk,
    input logic [7:0] in,
    output logic [7:0] pedge
);
    logic [7:0] prev_in;

    always_ff @(posedge clk) begin
        prev_in <= in;
    end

    always_comb begin
        // A positive edge is detected when the previous input was 0 
        // and the current input is 1.
        pedge = (~prev_in) & in;
    end
endmodule
