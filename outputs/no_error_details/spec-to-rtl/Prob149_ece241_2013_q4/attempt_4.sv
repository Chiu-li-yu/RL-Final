module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);
    logic [1:0] current_level;
    logic [1:0] prev_level;
    logic r_dfr;

    always @(*) begin
        if (s == 3'b111) current_level = 2'd3;
        else if (s == 3'b011) current_level = 2'd2;
        else if (s == 3'b001) current_level = 2'd1;
        else current_level = 2'd0;
    end

    // Nominal flow outputs
    assign fr2 = (current_level == 2'd0);
    assign fr1 = (current_level == 2'd0 || current_level == 2'd1);
    assign fr0 = (current_level == 2'd0 || current_level == 2'd1 || current_level == 2'd2);

    // Mealy-style dfr: dfr should be active if water level is currently dropping
    // But reset requirement: "all four outputs asserted". 
    // If we make dfr a purely combinational output based on (prev > current),
    // then we need to store the PREVIOUS level.
    
    assign dfr = (reset) ? 1'b1 : (prev_level > current_level);

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;
        end else begin
            prev_level <= current_level;
        end
    end
endmodule