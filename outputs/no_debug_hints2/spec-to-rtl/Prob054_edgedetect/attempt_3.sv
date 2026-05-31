module TopModule(
    input clk,
    input [7:0] in,
    output logic [7:0] pedge
);
    logic [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;
    end

    // The logic should be the current 'in' and NOT the previous 'in'
    // This correctly identifies a 0 -> 1 transition.
    // Example: prev=0, curr=1 -> (~0 & 1) = 1 (pedge=1)
    // Example: prev=1, curr=1 -> (~1 & 1) = 0 (pedge=0)
    // Example: prev=0, curr=0 -> (~0 & 0) = 0 (pedge=0)
    // Example: prev=1, curr=0 -> (~1 & 0) = 0 (pedge=0)
    
    always @(*) begin
        pedge = (~prev_in & in);
    end

endmodule
