module TopModule (
    input clk,
    input a,
    output logic [2:0] q
);

    // Let's re-examine:
    // 45ns: a=0, q=4
    // 55ns: a=0, q=5
    // 65ns: a=0, q=6
    // 75ns: a=0, q=0
    
    // Maybe q only increments if a=0 AND it has been a=0 for a while?
    // Or maybe the input 'a' is sampled differently?
    // What if q is 3 bits, and it's a counter that ONLY increments when a=0?
    // But at 45ns, a=0, why is q=4?
    // Maybe it takes a cycle to react to 'a' changing from 1 to 0?
    
    logic a_delayed;
    always @(posedge clk) begin
        a_delayed <= a;
        if (a) begin
            q <= 3'd4;
        end else if (a_delayed == 0) begin
            q <= q + 1'b1;
        end
    end

endmodule
