module TopModule (
    input clk,
    input reset,
    input ena,
    output logic pm,
    output logic [7:0] hh,
    output logic [7:0] mm,
    output logic [7:0] ss
);

    logic [3:0] ss_ones, ss_tens;
    logic [3:0] mm_ones, mm_tens;
    logic [3:0] hh_ones, hh_tens;
    logic pm_reg;

    assign ss = {ss_tens, ss_ones};
    assign mm = {mm_tens, mm_ones};
    assign hh = {hh_tens, hh_ones};
    assign pm = pm_reg;

    always @(posedge clk) begin
        if (reset) begin
            ss_ones <= 4'd0; ss_tens <= 4'd0;
            mm_ones <= 4'd0; mm_tens <= 4'd0;
            hh_ones <= 4'd2; hh_tens <= 4'd1;
            pm_reg  <= 1'b0; // AM
        end else if (ena) begin
            // Seconds
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                    // Minutes
                    if (mm_ones == 4'd9) begin
                        mm_ones <= 4'd0;
                        if (mm_tens == 4'd5) begin
                            mm_tens <= 4'd0;
                            // Hours
                            if (hh_ones == 4'd2 && hh_tens == 4'd1) begin
                                hh_ones <= 4'd1; hh_tens <= 4'd0;
                            end else if (hh_ones == 4'd9) begin
                                hh_ones <= 4'd0; hh_tens <= hh_tens + 1'b1;
                            end else begin
                                hh_ones <= hh_ones + 1'b1;
                            end
                            // PM Toggle
                            if (hh_ones == 4'd1 && hh_tens == 4'd1) begin
                                pm_reg <= ~pm_reg;
                            end
                        end else begin
                            mm_tens <= mm_tens + 1'b1;
                        end
                    end else begin
                        mm_ones <= mm_ones + 1'b1;
                    end
                end else begin
                    ss_tens <= ss_tens + 1'b1;
                end
            end else begin
                ss_ones <= ss_ones + 1'b1;
            end
        end
    end
endmodule
