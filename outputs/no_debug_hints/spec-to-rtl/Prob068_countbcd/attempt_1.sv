module TopModule (
    input clk,
    input reset,
    output logic [2:0] ena,
    output logic [15:0] q
);

    // BCD digits
    logic [3:0] digit0, digit1, digit2, digit3;

    always_ff @(posedge clk) begin
        if (reset) begin
            digit0 <= 4'd0;
            digit1 <= 4'd0;
            digit2 <= 4'd0;
            digit3 <= 4'd0;
        end else begin
            // Increment digit0
            if (digit0 == 4'd9) digit0 <= 4'd0;
            else digit0 <= digit0 + 4'd1;

            // Increment digit1
            if (digit0 == 4'd9) begin
                if (digit1 == 4'd9) digit1 <= 4'd0;
                else digit1 <= digit1 + 4'd1;
            end

            // Increment digit2
            if (digit0 == 4'd9 && digit1 == 4'd9) begin
                if (digit2 == 4'd9) digit2 <= 4'd0;
                else digit2 <= digit2 + 4'd1;
            end

            // Increment digit3
            if (digit0 == 4'd9 && digit1 == 4'd9 && digit2 == 4'd9) begin
                if (digit3 == 4'd9) digit3 <= 4'd0;
                else digit3 <= digit3 + 4'd1;
            end
        end
    end

    // Assign outputs
    assign q = {digit3, digit2, digit1, digit0};
    assign ena[0] = (digit0 == 4'd9);
    assign ena[1] = (digit0 == 4'd9 && digit1 == 4'd9);
    assign ena[2] = (digit0 == 4'd9 && digit1 == 4'd9 && digit2 == 4'd9);

endmodule