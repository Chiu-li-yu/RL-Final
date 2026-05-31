module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);
    // Based on standard implementation of DFF with MUX
    // D = L ? r_in : q_in
    logic d;
    logic q_reg;
    
    assign Q = q_reg;

    always @(*) begin
        d = L ? r_in : q_in;
    end

    always @(posedge clk) begin
        q_reg <= d;
    end
endmodule
