
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    logic [511:0] q_reg;
    logic [511:0] q_next;

    assign q = q_reg;

    always @(*) begin
        for (int i = 0; i < 512; i++) begin
            logic left;
            logic right;
            
            left = (i == 0) ? 1'b0 : q_reg[i-1];
            right = (i == 511) ? 1'b0 : q_reg[i+1];
            
            q_next[i] = left ^ right;
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q_reg <= data;
        end else begin
            q_reg <= q_next;
        end
    end

endmodule
