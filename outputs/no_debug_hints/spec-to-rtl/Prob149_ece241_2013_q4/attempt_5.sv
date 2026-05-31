module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    logic [2:0] prev_s;
    logic [1:0] curr_lvl, prev_lvl;

    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    always @(*) begin
        case(s)
            3'b111: curr_lvl = 2'd3;
            3'b011: curr_lvl = 2'd2;
            3'b001: curr_lvl = 2'd1;
            default: curr_lvl = 2'd0;
        endcase
        
        case(prev_s)
            3'b111: prev_lvl = 2'd3;
            3'b011: prev_lvl = 2'd2;
            3'b001: prev_lvl = 2'd1;
            default: prev_lvl = 2'd0;
        endcase
    end

    logic fr2_r, fr1_r, fr0_r, dfr_r;

    always @(posedge clk) begin
        if (reset) begin
            fr2_r <= 1; fr1_r <= 1; fr0_r <= 1; dfr_r <= 1;
        end else begin
            fr2_r <= (s == 3'b000);
            fr1_r <= (s == 3'b000 || s == 3'b001);
            fr0_r <= (s == 3'b000 || s == 3'b001 || s == 3'b011);
            // dfr logic:
            // 1. Below s[0] (already covered by fr2, but requirement says s[0] no sensors asserted)
            // 2. Previous level > Current level: (prev_lvl > curr_lvl)
            // Wait, does "supplemental" mean it is ONLY triggered by the change?
            // "If the sensor change indicates... increased by opening the Supplemental flow valve"
            // So if no change, dfr = (s == 3'b000). 
            // My code: if change happens, and prev > curr, dfr = 1. Else dfr = (s==000).
            if (s != prev_s && prev_lvl > curr_lvl)
                dfr_r <= 1;
            else if (s == 3'b000)
                dfr_r <= 1;
            else
                dfr_r <= 0;
        end
    end

    assign fr2 = fr2_r;
    assign fr1 = fr1_r;
    assign fr0 = fr0_r;
    assign dfr = dfr_r;

endmodule