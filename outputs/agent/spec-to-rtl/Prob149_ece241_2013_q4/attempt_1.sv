
module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    logic [1:0] L_curr;
    logic [1:0] L_curr_reg;
    logic [1:0] L_prev;

    // Determine current level based on sensors
    always @(*) begin
        if (s == 3'b111)
            L_curr = 2'd3;
        else if (s == 3'b011)
            L_curr = 2'd2;
        else if (s == 3'b001)
            L_curr = 2'd1;
        else
            L_curr = 2'd0;
    end

    // Track current and previous levels
    always @(posedge clk) begin
        if (reset) begin
            L_curr_reg <= 2'd0;
            L_prev <= 2'd0;
        end else begin
            if (L_curr != L_curr_reg) begin
                L_prev <= L_curr_reg;
            end
            L_curr_reg <= L_curr;
        end
    end

    // Output logic
    logic next_fr2, next_fr1, next_fr0, next_dfr;

    always @(*) begin
        case (L_curr)
            2'd3: begin
                next_fr2 = 1'b0;
                next_fr1 = 1'b0;
                next_fr0 = 1'b0;
                next_dfr = 1'b0;
            end
            2'd2: begin
                next_fr2 = 1'b0;
                next_fr1 = 1'b0;
                next_fr0 = 1'b1;
                next_dfr = (2'd2 > L_prev) ? 1'b1 : 1'b0;
            end
            2'd1: begin
                next_fr2 = 1'b0;
                next_fr1 = 1'b1;
                next_fr0 = 1'b1;
                next_dfr = (2'd1 > L_prev) ? 1'b1 : 1'b0;
            end
            2'd0: begin
                next_fr2 = 1'b1;
                next_fr1 = 1'b1;
                next_fr0 = 1'b1;
                next_dfr = 1'b1;
            end
            default: begin
                next_fr2 = 1'b0;
                next_fr1 = 1'b0;
                next_fr0 = 1'b0;
                next_dfr = 1'b0;
            end
        endcase
    end

    assign fr2 = next_fr2;
    assign fr1 = next_fr1;
    assign fr0 = next_fr0;
    assign dfr = next_dfr;

endmodule
