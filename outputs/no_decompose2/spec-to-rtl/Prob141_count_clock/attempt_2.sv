module TopModule (
    input clk,
    input reset,
    input ena,
    output logic pm,
    output logic [7:0] hh,
    output logic [7:0] mm,
    output logic [7:0] ss
);

    logic [3:0] s1, s10, m1, m10, h1, h10;
    assign ss = {s10, s1};
    assign mm = {m10, m1};
    assign hh = {h10, h1};

    always @(posedge clk) begin
        if (reset) begin
            s1 <= 0; s10 <= 0;
            m1 <= 0; m10 <= 0;
            h1 <= 2; h10 <= 1;
            pm <= 0;
        end else if (ena) begin
            if (s1 != 9) s1 <= s1 + 1;
            else begin
                s1 <= 0;
                if (s10 != 5) s10 <= s10 + 1;
                else begin
                    s10 <= 0;
                    if (m1 != 9) m1 <= m1 + 1;
                    else begin
                        m1 <= 0;
                        if (m10 != 5) m10 <= m10 + 1;
                        else begin
                            m10 <= 0;
                            // Hours logic
                            if (h10 == 1 && h1 == 2) begin h1 <= 1; h10 <= 0; end
                            else if (h1 == 9) begin h1 <= 0; h10 <= h10 + 1; end
                            else begin h1 <= h1 + 1; end
                            
                            // PM toggle at 11:59:59 -> 12:00:00
                            if (h10 == 1 && h1 == 1) pm <= ~pm;
                        end
                    end
                end
            end
        end
    end
endmodule