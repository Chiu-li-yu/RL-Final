module TopModule (
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

    always @(posedge clk) begin
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

    always @(*) begin
        // Seconds Logic
        if (ss[3:0] == 9) begin
            ss_next = {ss[7:4] + 1'b1, 4'h0};
            if (ss[7:4] == 5) ss_next = 8'h00;
        end else begin
            ss_next = ss + 1'b1;
        end

        // Minutes Logic
        mm_next = mm;
        if (ss[3:0] == 9 && ss[7:4] == 5) begin
            if (mm[3:0] == 9) begin
                mm_next = {mm[7:4] + 1'b1, 4'h0};
                if (mm[7:4] == 5) mm_next = 8'h00;
            end else begin
                mm_next = mm + 1'b1;
            end
        end

        // Hours & PM Logic
        hh_next = hh;
        pm_next = pm;
        if (ss[3:0] == 9 && ss[7:4] == 5 && mm[3:0] == 9 && mm[7:4] == 5) begin
            if (hh == 8'h11) begin
                hh_next = 8'h12;
                pm_next = !pm;
            end else if (hh == 8'h12) begin
                hh_next = 8'h01;
            end else begin
                if (hh[3:0] == 9) begin
                    hh_next = {hh[7:4] + 1'b1, 4'h0};
                end else begin
                    hh_next = hh + 1'b1;
                end
            end
        end
    end
endmodule
