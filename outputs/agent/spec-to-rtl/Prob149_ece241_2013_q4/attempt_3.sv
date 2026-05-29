
module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    localparam L0 = 3'd0, L1_R = 3'd1, L1_F = 3'd2, L2_R = 3'd3, L2_F = 3'd4, L3 = 3'd5;
    logic [2:0] state, next_state;

    logic [1:0] L_curr;
    always @(*) begin
        if (s[2]) L_curr = 2'd3;
        else if (s[1]) L_curr = 2'd2;
        else if (s[0]) L_curr = 2'd1;
        else L_curr = 2'd0;
    end

    always @(posedge clk) begin
        if (reset) state <= L0;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            L0: begin
                if (L_curr == 2'd1) next_state = L1_R;
                else if (L_curr == 2'd2) next_state = L2_R;
                else if (L_curr == 2'd3) next_state = L3;
                else next_state = L0;
            end
            L1_R: begin
                if (L_curr == 2'd0) next_state = L0;
                else if (L_curr == 2'd2) next_state = L2_R;
                else if (L_curr == 2'd3) next_state = L3;
                else next_state = L1_R;
            end
            L1_F: begin
                if (L_curr == 2'd0) next_state = L0;
                else if (L_curr == 2'd2) next_state = L2_R;
                else if (L_curr == 2'd3) next_state = L3;
                else next_state = L1_F;
            end
            L2_R: begin
                if (L_curr == 2'd0) next_state = L0;
                else if (L_curr == 2'd1) next_state = L1_F;
                else if (L_curr == 2'd3) next_state = L3;
                else next_state = L2_R;
            end
            L2_F: begin
                if (L_curr == 2'd0) next_state = L0;
                else if (L_curr == 2'd1) next_state = L1_F;
                else if (L_curr == 2'd3) next_state = L3;
                else next_state = L2_F;
            end
            L3: begin
                if (L_curr == 2'd0) next_state = L0;
                else if (L_curr == 2'd1) next_state = L1_F;
                else if (L_curr == 2'd2) next_state = L2_F;
                else next_state = L3;
            end
            default: next_state = L0;
        endcase
    end

    assign fr2 = (state == L0) ? 1'b1 : 1'b0;
    assign fr1 = (state == L0 || state == L1_R || state == L1_F) ? 1'b1 : 1'b0;
    assign fr0 = (state == L0 || state == L1_R || state == L1_F || state == L2_R || state == L2_F) ? 1'b1 : 1'b0;
    assign dfr = (state == L0 || state == L1_R || state == L2_R) ? 1'b1 : 1'b0;

endmodule
