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

    always_ff @(posedge clk) begin
        if (reset) begin
            ss_ones <= 4'd0; ss_tens <= 4'd0;
            mm_ones <= 4'd0; mm_tens <= 4'd0;
            hh_ones <= 4'd2; hh_tens <= 4'd1;
            pm <= 1'b0;
        end else if (ena) begin
            // Seconds
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                if (ss_tens == 4'd5) ss_tens <= 4'd0;
                else ss_tens <= ss_tens + 1'b1;
            end else begin
                ss_ones <= ss_ones + 1'b1;
            end

            // Minutes
            if (ss_ones == 4'd9 && ss_tens == 4'd5) begin
                if (mm_ones == 4'd9) begin
                    mm_ones <= 4'd0;
                    if (mm_tens == 4'd5) mm_tens <= 4'd0;
                    else mm_tens <= mm_tens + 1'b1;
                end else begin
                    mm_ones <= mm_ones + 1'b1;
                end
            end

            // Hours
            if (ss_ones == 4'd9 && ss_tens == 4'd5 && mm_ones == 4'd9 && mm_tens == 4'd5) begin
                if (hh_ones == 4'd2 && hh_tens == 4'd1) begin // 12 -> 01
                    hh_ones <= 4'd1; hh_tens <= 4'd0;
                end else if (hh_ones == 4'd9) begin // 09 -> 10
                    hh_ones <= 4'd0; hh_tens <= 4'd1;
                end else begin // Increment
                    hh_ones <= hh_ones + 1'b1;
                    if (hh_ones == 4'd1 && hh_tens == 4'd1) begin // 11 -> 12
                        hh_ones <= 4'd2; hh_tens <= 4'd1;
                    end
                end

                // AM/PM Toggle
                if (hh_ones == 4'd1 && hh_tens == 4'd1) begin
                    pm <= ~pm;
                end
            end
        end
    end

endmodule
