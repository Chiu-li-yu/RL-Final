
module TopModule (
    input  clk,
    input  reset,
    input  ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    logic [3:0] ss_ones, ss_tens;
    logic [3:0] mm_ones, mm_tens;
    logic [3:0] hour_count;
    logic pm_reg;

    logic [3:0] hh_ones, hh_tens;

    assign pm = pm_reg;
    assign ss = {ss_tens, ss_ones};
    assign mm = {mm_tens, mm_ones};
    assign hh = {hh_tens, hh_ones};

    always @(*) begin
        if (hour_count >= 4'd10) begin
            hh_tens = 4'd1;
            hh_ones = hour_count - 4'd10;
        end else begin
            hh_tens = 4'd0;
            hh_ones = hour_count;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            ss_ones <= 4'd0;
            ss_tens <= 4'd0;
            mm_ones <= 4'd0;
            mm_tens <= 4'd0;
            hour_count <= 4'd12;
            pm_reg <= 1'b0;
        end else if (ena) begin
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                    if (mm_ones == 4'd9) begin
                        mm_ones <= 4'd0;
                        if (mm_tens == 4'd5) begin
                            mm_tens <= 4'd0;
                            if (hour_count == 4'd12) begin
                                hour_count <= 4'd1;
                            end else if (hour_count == 4'd11) begin
                                hour_count <= 4'd12;
                                pm_reg <= !pm_reg;
                            end else begin
                                hour_count <= hour_count + 4'd1;
                            end
                        end else begin
                            mm_tens <= mm_tens + 4'd1;
                        end
                    end else begin
                        mm_ones <= mm_ones + 4'd1;
                    end
                end else begin
                    ss_tens <= ss_tens + 4'd1;
                end
            end else begin
                ss_ones <= ss_ones + 4'd1;
            end
        end
    end

endmodule
