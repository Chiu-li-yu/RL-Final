module TopModule (
    input clk,
    input d,
    output q
);
    logic q1, q2;

    // Based on the classic design:
    // q1 captures at posedge
    // q2 captures at negedge
    // q = (clk ? q1 : q2)
    
    always @(posedge clk)
        q1 <= d;
        
    always @(negedge clk)
        q2 <= d;
        
    assign q = clk ? q1 : q2;
endmodule