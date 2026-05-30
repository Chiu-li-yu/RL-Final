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

    assign ss = {ss_tens, ss_ones};
    assign mm = {mm_tens, mm_ones};
    assign hh = {hh_tens, hh_ones};

    always @(posedge clk) begin
        if (reset) begin
            ss_ones <= 0; ss_tens <= 0;
            mm_ones <= 0; mm_tens <= 0;
            hh_ones <= 2; hh_tens <= 1;
            pm <= 0;
        end else if (ena) begin
            // Seconds
            if (ss_ones == 9) begin
                ss_ones <= 0;
                if (ss_tens == 5) ss_tens <= 0;
                else ss_tens <= ss_tens + 1;
            end else begin
                ss_ones <= ss_ones + 1;
            end

            // Minutes increment only when seconds roll over
            if (ss_ones == 9 && ss_tens == 5) begin
                if (mm_ones == 9) begin
                    mm_ones <= 0;
                    if (mm_tens == 5) mm_tens <= 0;
                    else mm_tens <= mm_tens + 1;
                end else begin
                    mm_ones <= mm_ones + 1;
                end

                // Hours increment only when minutes roll over
                if (mm_ones == 9 && mm_tens == 5) begin
                    if (hh_ones == 2 && hh_tens == 1) begin // 12 -> 01
                        hh_ones <= 1; hh_tens <= 0;
                    end else if (hh_ones == 9) begin // 09 -> 10
                        hh_ones <= 0; hh_tens <= 1;
                    end else begin
                        hh_ones <= hh_ones + 1;
                    end

                    // AM/PM Toggle
                    if (hh_ones == 1 && hh_tens == 1) begin // 11 -> 12
                        pm <= ~pm;
                    end
                end
            end
        end
    end
endmodule