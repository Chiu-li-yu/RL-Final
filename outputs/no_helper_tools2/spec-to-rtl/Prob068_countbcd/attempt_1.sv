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
            // Increment d0
            if (d0 == 4'd9) begin
                d0 <= 4'd0;
                // Increment d1
                if (d1 == 4'd9) begin
                    d1 <= 4'd0;
                    // Increment d2
                    if (d2 == 4'd9) begin
                        d2 <= 4'd0;
                        // Increment d3
                        if (d3 == 4'd9) begin
                            d3 <= 4'd0;
                        end else begin
                            d3 <= d3 + 1'b1;
                        end
                    end else begin
                        d2 <= d2 + 1'b1;
                    end
                end else begin
                    d1 <= d1 + 1'b1;
                end
            end else begin
                d0 <= d0 + 1'b1;
            end
        end
    end

    always @(*) begin
        ena[0] = (d0 == 4'd9);
        ena[1] = (d0 == 4'd9 && d1 == 4'd9);
        ena[2] = (d0 == 4'd9 && d1 == 4'd9 && d2 == 4'd9);
        q = {d3, d2, d1, d0};
    end

endmodule
