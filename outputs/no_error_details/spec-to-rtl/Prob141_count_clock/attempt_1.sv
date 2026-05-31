module TopModule (
    input clk,
    input reset,
    input ena,
    output logic pm,
    output logic [7:0] hh,
    output logic [7:0] mm,
    output logic [7:0] ss
);

    // BCD increment logic
    function [7:0] bcd_inc;
        input [7:0] val;
        logic [3:0] tens, ones;
        begin
            tens = val[7:4];
            ones = val[3:0];
            if (ones == 4'd9) begin
                ones = 4'd0;
                if (tens == 4'd9) tens = 4'd0;
                else tens = tens + 1'b1;
            end else begin
                ones = ones + 1'b1;
            end
            bcd_inc = {tens, ones};
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12;
            pm <= 1'b0;
        end else if (ena) begin
            // Seconds
            if (ss == 8'h59) begin
                ss <= 8'h00;
                // Minutes
                if (mm == 8'h59) begin
                    mm <= 8'h00;
                    // Hours
                    if (hh == 8'h12) hh <= 8'h01;
                    else if (hh == 8'h11) begin
                        hh <= 8'h12;
                        pm <= ~pm;
                    end else hh <= bcd_inc(hh);
                end else begin
                    mm <= bcd_inc(mm);
                end
            end else begin
                ss <= bcd_inc(ss);
            end
        end
    end

endmodule