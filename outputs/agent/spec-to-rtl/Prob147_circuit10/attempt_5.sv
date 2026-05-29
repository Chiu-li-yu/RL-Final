
module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

    logic s;
    
    assign q = a ^ b ^ s;
    assign state = s;

    always @(posedge clk) begin
        s <= s ^ a;
    end
endmodule
