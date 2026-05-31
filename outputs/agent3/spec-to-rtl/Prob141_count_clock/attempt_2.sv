module TopModule(
    input clk,
    input reset,
    input ena,
    output logic pm,
    output logic [7:0] hh,
    output logic [7:0] mm,
    output logic [7:0] ss
);

    logic [3:0] ss0, ss1, mm0, mm1, hh0, hh1;

    assign ss = {ss1, ss0};
    assign mm = {mm1, mm0};
    assign hh = {hh1, hh0};

    always_ff @(posedge clk) begin
        if (reset) begin
            ss0 <= 4'd0; ss1 <= 4'd0;
            mm0 <= 4'd0; mm1 <= 4'd0;
            hh0 <= 4'd2; hh1 <= 4'd1;
            pm <= 1'b0;
        end else if (ena) begin
            // Increment Seconds
            if (ss0 == 4'd9) begin
                ss0 <= 4'd0;
                if (ss1 == 4'd5) begin
                    ss1 <= 4'd0;
                    // Increment Minutes
                    if (mm0 == 4'd9) begin
                        mm0 <= 4'd0;
                        if (mm1 == 4'd5) begin
                            mm1 <= 4'd0;
                            // Increment Hours
                            if (hh1 == 4'd1 && hh0 == 4'd2) begin
                                hh1 <= 4'd0; hh0 <= 4'd1;
                            end else if (hh0 == 4'd9) begin
                                hh0 <= 4'd0; hh1 <= 4'd1;
                            end else begin
                                hh0 <= hh0 + 1'b1;
                            end
                            // PM logic: flip when reaching 12:00
                            if (hh1 == 4'd1 && hh0 == 4'd1) begin
                                pm <= ~pm;
                            end
                        end else begin
                            mm1 <= mm1 + 1'b1;
                        end
                    end else begin
                        mm0 <= mm0 + 1'b1;
                    end
                end else begin
                    ss1 <= ss1 + 1'b1;
                end
            end else begin
                ss0 <= ss0 + 1'b1;
            end
        end
    end
endmodule