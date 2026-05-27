module TopModule(
    input clk,
    input reset,
    input ena,
    output logic pm,
    output logic [7:0] hh,
    output logic [7:0] mm,
    output logic [7:0] ss
);

    logic [7:0] ss_next, mm_next, hh_next;
    logic pm_next;

    always_ff @(posedge clk) begin
        if (reset) begin
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12;
            pm <= 1'b0;
        end else if (ena) begin
            ss <= ss_next;
            mm <= mm_next;
            hh <= hh_next;
            pm <= pm_next;
        end
    end

    always_comb begin
        ss_next = ss;
        mm_next = mm;
        hh_next = hh;
        pm_next = pm;

        // Seconds logic
        if (ss[3:0] == 4'd9) begin
            ss_next[3:0] = 4'd0;
            if (ss[7:4] == 4'd5) begin
                ss_next[7:4] = 4'd0;
                // Minutes logic
                if (mm[3:0] == 4'd9) begin
                    mm_next[3:0] = 4'd0;
                    if (mm[7:4] == 4'd5) begin
                        mm_next[7:4] = 4'd0;
                        // Hours logic
                        if (hh == 8'h12) begin
                            hh_next = 8'h01;
                        end else if (hh == 8'h11) begin
                            hh_next = 8'h12;
                            pm_next = ~pm;
                        end else if (hh[3:0] == 4'd9) begin
                            hh_next[3:0] = 4'd0;
                            hh_next[7:4] = hh[7:4] + 1'b1;
                        end else begin
                            hh_next[3:0] = hh[3:0] + 1'b1;
                        end
                    end else begin
                        mm_next[7:4] = mm[7:4] + 1'b1;
                    end
                end else begin
                    mm_next[3:0] = mm[3:0] + 1'b1;
                end
            end else begin
                ss_next[7:4] = ss[7:4] + 1'b1;
            end
        end else begin
            ss_next[3:0] = ss[3:0] + 1'b1;
        end
    end

endmodule
