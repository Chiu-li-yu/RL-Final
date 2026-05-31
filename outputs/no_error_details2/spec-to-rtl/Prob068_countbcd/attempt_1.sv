module TopModule(
    input clk,
    input reset,
    output logic [2:0] ena,
    output logic [15:0] q
);

    logic [3:0] d0, d1, d2, d3;
    logic carry0, carry1, carry2;

    always_ff @(posedge clk) begin
        if (reset) begin
            d0 <= 4'd0;
            d1 <= 4'd0;
            d2 <= 4'd0;
            d3 <= 4'd0;
        end else begin
            // Digit 0
            if (d0 == 4'd9) d0 <= 4'd0;
            else d0 <= d0 + 4'd1;

            // Digit 1
            if (carry0) begin
                if (d1 == 4'd9) d1 <= 4'd0;
                else d1 <= d1 + 4'd1;
            end

            // Digit 2
            if (carry0 && carry1) begin
                if (d2 == 4'd9) d2 <= 4'd0;
                else d2 <= d2 + 4'd1;
            end

            // Digit 3
            if (carry0 && carry1 && carry2) begin
                if (d3 == 4'd9) d3 <= 4'd0;
                else d3 <= d3 + 4'd1;
            end
        end
    end

    always @(*) begin
        carry0 = (d0 == 4'd9);
        carry1 = (d1 == 4'd9);
        carry2 = (d2 == 4'd9);
        
        ena[0] = carry0;
        ena[1] = carry0 && carry1;
        ena[2] = carry0 && carry1 && carry2;

        q = {d3, d2, d1, d0};
    end

endmodule