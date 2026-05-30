module TopModule (
    input clk,
    input reset,
    output logic [2:0] ena,
    output logic [15:0] q
);

    // BCD digits
    logic [3:0] ones, tens, hundreds, thousands;

    // ena output logic
    always @(*) begin
        ena[0] = (ones == 4'd9);
        ena[1] = (ones == 4'd9 && tens == 4'd9);
        ena[2] = (ones == 4'd9 && tens == 4'd9 && hundreds == 4'd9);
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit
            if (ones == 4'd9) ones <= 4'd0;
            else ones <= ones + 1'b1;

            // Tens digit
            if (ones == 4'd9) begin
                if (tens == 4'd9) tens <= 4'd0;
                else tens <= tens + 1'b1;
            end

            // Hundreds digit
            if (ones == 4'd9 && tens == 4'd9) begin
                if (hundreds == 4'd9) hundreds <= 4'd0;
                else hundreds <= hundreds + 1'b1;
            end

            // Thousands digit
            if (ones == 4'd9 && tens == 4'd9 && hundreds == 4'd9) begin
                if (thousands == 4'd9) thousands <= 4'd0;
                else thousands <= thousands + 1'b1;
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule