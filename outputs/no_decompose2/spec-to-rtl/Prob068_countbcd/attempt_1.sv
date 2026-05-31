module TopModule (
    input clk,
    input reset,
    output logic [2:0] ena,
    output logic [15:0] q
);

    logic [3:0] d0, d1, d2, d3;

    always @(posedge clk) begin
        if (reset) begin
            d0 <= 4'd0;
            d1 <= 4'd0;
            d2 <= 4'd0;
            d3 <= 4'd0;
        end else begin
            // Digit 0 (ones)
            if (d0 == 4'd9) d0 <= 4'd0;
            else d0 <= d0 + 4'd1;

            // Digit 1 (tens)
            if (d0 == 4'd9) begin
                if (d1 == 4'd9) d1 <= 4'd0;
                else d1 <= d1 + 4'd1;
            end

            // Digit 2 (hundreds)
            if (d0 == 4'd9 && d1 == 4'd9) begin
                if (d2 == 4'd9) d2 <= 4'd0;
                else d2 <= d2 + 4'd1;
            end

            // Digit 3 (thousands)
            if (d0 == 4'd9 && d1 == 4'd9 && d2 == 4'd9) begin
                if (d3 == 4'd9) d3 <= 4'd0;
                else d3 <= d3 + 4'd1;
            end
        end
    end

    // Enable signals: high when the next digit increments
    always @(*) begin
        ena[0] = (d0 == 4'd9);
        ena[1] = (d0 == 4'd9 && d1 == 4'd9);
        ena[2] = (d0 == 4'd9 && d1 == 4'd9 && d2 == 4'd9);
    end

    assign q = {d3, d2, d1, d0};

endmodule
