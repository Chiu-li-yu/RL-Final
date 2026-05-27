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
            // Digit 0 (ones)
            if (digit0 == 4'd9) begin
                digit0 <= 4'd0;
                
                // Digit 1 (tens)
                if (digit1 == 4'd9) begin
                    digit1 <= 4'd0;
                    
                    // Digit 2 (hundreds)
                    if (digit2 == 4'd9) begin
                        digit2 <= 4'd0;
                        
                        // Digit 3 (thousands)
                        if (digit3 == 4'd9) begin
                            digit3 <= 4'd0;
                        end else begin
                            digit3 <= digit3 + 1'b1;
                        end
                    end else begin
                        digit2 <= digit2 + 1'b1;
                    end
                end else begin
                    digit1 <= digit1 + 1'b1;
                end
            end else begin
                digit0 <= digit0 + 1'b1;
            end
        end
    end

    // Enable logic
    always @(*) begin
        ena[0] = (digit0 == 4'd9);
        ena[1] = (digit0 == 4'd9 && digit1 == 4'd9);
        ena[2] = (digit0 == 4'd9 && digit1 == 4'd9 && digit2 == 4'd9);
    end

    assign q = {digit3, digit2, digit1, digit0};

endmodule
