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
        // Level mapping
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

        if (reset) begin
            fr0 = 1; fr1 = 1; fr2 = 1; dfr = 1;
        end else begin
            fr2 = (s == 3'b000);
            fr1 = (s == 3'b000 || s == 3'b001);
            fr0 = (s == 3'b000 || s == 3'b001 || s == 3'b011);
            dfr = (s == 3'b000) || (prev_lvl > curr_lvl);
        end
    end
endmodule