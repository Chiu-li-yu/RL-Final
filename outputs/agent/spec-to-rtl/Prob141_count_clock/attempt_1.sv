module TopModule (
    input clk,
    input reset,
    input ena,
    output logic pm,
    output logic [7:0] hh,
    output logic [7:0] mm,
    output logic [7:0] ss
);

    logic [7:0] s_ss, s_mm, s_hh;
    logic s_pm;

    always @(posedge clk) begin
        if (reset) begin
            s_ss <= 8'h00;
            s_mm <= 8'h00;
            s_hh <= 8'h12;
            s_pm <= 1'b0; // AM
        end else if (ena) begin
            // Seconds
            if (s_ss == 8'h59) begin
                s_ss <= 8'h00;
                // Minutes
                if (s_mm == 8'h59) begin
                    s_mm <= 8'h00;
                    // Hours
                    if (s_hh == 8'h12) s_hh <= 8'h01;
                    else if (s_hh == 8'h09) s_hh <= 8'h10;
                    else s_hh <= s_hh + 8'h01;
                    
                    if (s_hh == 8'h11) s_pm <= ~s_pm;
                end else begin
                    if (s_mm[3:0] == 4'd9) begin
                        s_mm <= {s_mm[7:4] + 1'b1, 4'd0};
                    end else begin
                        s_mm <= s_mm + 8'h01;
                    end
                end
            end else begin
                if (s_ss[3:0] == 4'd9) begin
                    s_ss <= {s_ss[7:4] + 1'b1, 4'd0};
                end else begin
                    s_ss <= s_ss + 8'h01;
                end
            end
        end
    end

    assign ss = s_ss;
    assign mm = s_mm;
    assign hh = s_hh;
    assign pm = s_pm;

endmodule
