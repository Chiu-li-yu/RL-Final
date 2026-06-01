module TopModule (
    input clk,
    input [7:0] in,
    output logic [7:0] pedge
);

    logic [7:0] prev_in;

    // Detect 0 to 1 at current cycle
    // Register it to output at next cycle
    
    always_ff @(posedge clk) begin
        prev_in <= in;
        pedge <= (in & ~prev_in);
    end

endmodule
