module TopModule (
    input clk,
    input reset,
    output logic [2:0] ena,
    output logic [15:0] q
);
    // BCD digits
    logic [3:0] d0, d1, d2, d3;

    // Internal enable signals for each stage
    // ena[0] -> digit 1
    // ena[1] -> digit 2
    // ena[2] -> digit 3
    always @(*) begin
        ena[0] = (d0 == 4'd9);
        ena[1] = (d0 == 4'd9 && d1 == 4'd9);
        ena[2] = (d0 == 4'd9 && d1 == 4'd9 && d2 == 4'd9);
    end

    // Sequential logic for each digit
    always @(posedge clk) begin
        if (reset) begin
            d0 <= 4'd0;
            d1 <= 4'd0;
            d2 <= 4'd0;
            d3 <= 4'd0;
        end else begin
            // Digit 0
            if (d0 == 4'd9) d0 <= 4'd0;
            else d0 <= d0 + 1'b1;

            // Digit 1
            if (ena[0]) begin
                if (d1 == 4'd9) d1 <= 4'd0;
                else d1 <= d1 + 1'b1;
            end

            // Digit 2
            if (ena[1]) begin
                if (d2 == 4'd9) d2 <= 4'd0;
                else d2 <= d2 + 1'b1;
            end

            // Digit 3
            if (ena[2]) begin
                if (d3 == 4'd9) d3 <= 4'd0;
                else d3 <= d3 + 1'b1;
            end
        end
    end

    assign q = {d3, d2, d1, d0};

endmodule
