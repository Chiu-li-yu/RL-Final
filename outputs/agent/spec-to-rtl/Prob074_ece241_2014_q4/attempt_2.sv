module TopModule(
    input clk,
    input x,
    output logic z
);

    logic q_xor, q_and, q_or;
    logic d_xor, d_and, d_or;

    always @(*) begin
        d_xor = x ^ q_xor;
        d_and = x & (~q_and);
        d_or  = x | (~q_or);
        
        z = ~(q_xor | q_and | q_or);
    end

    // Use initial for testbench/simulation compliance 
    // and standard reset-less behavior for synthesizeable code.
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or  = 1'b0;
    end

    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

endmodule
