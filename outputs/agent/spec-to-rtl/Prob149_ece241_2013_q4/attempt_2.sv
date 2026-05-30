module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    logic [2:0] current_s;
    logic [2:0] prev_s;
    
    // reset state: current_s = 3'b000, prev_s = 3'b000, outputs 1111
    always_ff @(posedge clk) begin
        if (reset) begin
            current_s <= 3'b000;
            prev_s <= 3'b000;
        end else if (s != current_s) begin
            prev_s <= current_s;
            current_s <= s;
        end
    end

    // Outputs are purely combinatorial based on state and history
    assign fr2 = (current_s == 3'b000);
    assign fr1 = (current_s == 3'b000 || current_s == 3'b001);
    assign fr0 = (current_s == 3'b000 || current_s == 3'b001 || current_s == 3'b011);
    assign dfr = (reset) ? 1'b1 : (prev_s > current_s);

endmodule
