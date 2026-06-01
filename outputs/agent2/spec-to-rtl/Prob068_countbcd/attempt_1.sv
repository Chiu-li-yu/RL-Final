module TopModule (
    input clk,
    input reset,
    output logic [2:0] ena,
    output logic [15:0] q
);

    logic [3:0] digit0, digit1, digit2, digit3;

    always @(posedge clk) begin
        if (reset) begin
            digit0 <= 4'd0;
            digit1 <= 4'd0;
            digit2 <= 4'd0;
            digit3 <= 4'd0;
        end else begin
            // Digit 0 (Ones)
            if (digit0 == 4'd9)
                digit0 <= 4'd0;
            else
                digit0 <= digit0 + 4'd1;

            // Digit 1 (Tens)
            if (digit0 == 4'd9) begin
                if (digit1 == 4'd9)
                    digit1 <= 4'd0;
                else
                    digit1 <= digit1 + 4'd1;
            end

            // Digit 2 (Hundreds)
            if (digit0 == 4'd9 && digit1 == 4'd9) begin
                if (digit2 == 4'd9)
                    digit2 <= 4'd0;
                else
                    digit2 <= digit2 + 4'd1;
            end

            // Digit 3 (Thousands)
            if (digit0 == 4'd9 && digit1 == 4'd9 && digit2 == 4'd9) begin
                if (digit3 == 4'd9)
                    digit3 <= 4'd0;
                else
                    digit3 <= digit3 + 4'd1;
            end
        end
    end

    always @(*) begin
        ena[0] = (digit0 == 4'd9);
        ena[1] = (digit0 == 4'd9 && digit1 == 4'd9);
        ena[2] = (digit0 == 4'd9 && digit1 == 4'd9 && digit2 == 4'd9);
        q = {digit3, digit2, digit1, digit0};
    end
endmodule
