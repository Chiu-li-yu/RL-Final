module TopModule(
    input clk,
    input reset,
    output logic [2:0] ena,
    output logic [15:0] q
);

    // BCD digits
    logic [3:0] d0, d1, d2, d3;

    // Enable signals for increments
    logic en0, en1, en2;

    assign en0 = (d0 == 4'd9);
    assign en1 = (en0 && (d1 == 4'd9));
    assign en2 = (en1 && (d2 == 4'd9));

    assign ena = {en2, en1, en0};
    assign q = {d3, d2, d1, d0};

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
            if (en0) begin
                if (d1 == 4'd9) d1 <= 4'd0;
                else d1 <= d1 + 4'd1;
            end

            // Digit 2
            if (en1) begin
                if (d2 == 4'd9) d2 <= 4'd0;
                else d2 <= d2 + 4'd1;
            end

            // Digit 3
            if (en2) begin
                if (d3 == 4'd9) d3 <= 4'd0;
                else d3 <= d3 + 4'd1;
            end
        end
    end

endmodule
