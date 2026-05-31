module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);
    logic [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;
    end

    always @(*) begin
        // pedge should be high if current bit is 1 and previous was 0
        // This creates a signal for one clock cycle following the transition
    end
    
    assign pedge = (in & ~prev_in);

endmodule
