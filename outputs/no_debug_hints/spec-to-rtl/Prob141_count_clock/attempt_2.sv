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
            end else ss_ones <= ss_ones + 1'b1;

            // Minutes (only when seconds roll)
            if (ss_ones == 4'd9 && ss_tens == 4'd5) begin
                if (mm_ones == 4'd9) begin
                    mm_ones <= 4'd0;
                    if (mm_tens == 4'd5) mm_tens <= 4'd0;
                    else mm_tens <= mm_tens + 1'b1;
                end else mm_ones <= mm_ones + 1'b1;
            end

            // Hours (only when minutes and seconds roll)
            if (ss_ones == 4'd9 && ss_tens == 4'd5 && mm_ones == 4'd9 && mm_tens == 4'd5) begin
                if (hh_tens == 4'd1 && hh_ones == 4'd2) begin
                    hh_tens <= 4'd0; hh_ones <= 4'd1;
                end else if (hh_ones == 4'd9) begin
                    hh_ones <= 4'd0; hh_tens <= hh_tens + 1'b1;
                end else begin
                    hh_ones <= hh_ones + 1'b1;
                end
                
                // Toggle PM at 11:59:59 -> 12:00:00
                if (hh_tens == 4'd1 && hh_ones == 4'd1) begin
                    pm <= ~pm;
                end
            end
        end
    end
endmodule
