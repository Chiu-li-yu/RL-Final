module TopModule (
    input clk,
    input reset,
    input ena,
    output logic pm,
    output logic [7:0] hh,
    output logic [7:0] mm,
    output logic [7:0] ss
);

    logic [3:0] ss0, ss1, mm0, mm1, hh0, hh1;
    logic pm_reg;

    assign ss = {ss1, ss0};
    assign mm = {mm1, mm0};
    assign hh = {hh1, hh0};
    assign pm = pm_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            ss0 <= 0; ss1 <= 0;
            mm0 <= 0; mm1 <= 0;
            hh0 <= 2; hh1 <= 1;
            pm_reg <= 0;
        end else if (ena) begin
            if (ss0 != 9) ss0 <= ss0 + 1;
            else begin
                ss0 <= 0;
                if (ss1 != 5) ss1 <= ss1 + 1;
                else begin
                    ss1 <= 0;
                    if (mm0 != 9) mm0 <= mm0 + 1;
                    else begin
                        mm0 <= 0;
                        if (mm1 != 5) mm1 <= mm1 + 1;
                        else begin
                            mm1 <= 0;
                            if (hh == 8'h11) begin
                                hh0 <= 2; hh1 <= 1;
                                pm_reg <= ~pm_reg;
                            end else if (hh == 8'h12) begin
                                hh0 <= 1; hh1 <= 0;
                            end else if (hh0 == 9) begin
                                hh0 <= 0; hh1 <= hh1 + 1;
                            end else begin
                                hh0 <= hh0 + 1;
                            end
                        end
                    end
                end
            end
        end
    end

endmodule
