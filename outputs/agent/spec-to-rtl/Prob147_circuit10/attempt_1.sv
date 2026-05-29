
module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

    logic s;
    
    // q = a ^ b ^ s
    assign q = a ^ b ^ s;
    assign state = s;

    always @(posedge clk) begin
        if ((a == b) && (s == 0) && (a == 1)) begin
            s <= 1;
        end else if ((a == b) && (s == 1) && (a == 0)) begin
            s <= 0;
        end else if ((a == b) && (s == 0) && (a == 0) && (q == 1)) begin
            // This is tricky. Let's try s_next = a ^ b ^ s?
            // No, let's try a simple s_next = (a && b) || (!a && !b && s)
            s <= s; 
        end else begin
            s <= s;
        end
    end
endmodule
