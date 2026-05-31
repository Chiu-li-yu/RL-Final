module TopModule (
    input clk,
    input reset,
    output logic [2:0] ena,
    output logic [15:0] q
);

    // BCD digits: q[3:0] (ones), q[7:4] (tens), q[11:8] (hundreds), q[15:12] (thousands)
    // ena[0] -> tens increment, ena[1] -> hundreds increment, ena[2] -> thousands increment

    logic [15:0] next_q;
    logic [2:0] next_ena;

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'h0000;
        end else begin
            q <= next_q;
        end
    end

    always @(*) begin
        next_q = q;
        next_ena = 3'b000;

        // Ones digit
        if (q[3:0] == 4'd9) begin
            next_q[3:0] = 4'd0;
            next_ena[0] = 1'b1; // Tens increment
        end else begin
            next_q[3:0] = q[3:0] + 1'b1;
            next_ena[0] = 1'b0;
        end

        // Tens digit
        if (next_ena[0]) begin
            if (q[7:4] == 4'd9) begin
                next_q[7:4] = 4'd0;
                next_ena[1] = 1'b1; // Hundreds increment
            end else begin
                next_q[7:4] = q[7:4] + 1'b1;
                next_ena[1] = 1'b0;
            end
        end else begin
            next_ena[1] = 1'b0;
        end

        // Hundreds digit
        if (next_ena[1]) begin
            if (q[11:8] == 4'd9) begin
                next_q[11:8] = 4'd0;
                next_ena[2] = 1'b1; // Thousands increment
            end else begin
                next_q[11:8] = q[11:8] + 1'b1;
                next_ena[2] = 1'b0;
            end
        end else begin
            next_ena[2] = 1'b0;
        end

        // Thousands digit
        if (next_ena[2]) begin
            if (q[15:12] == 4'd9) begin
                next_q[15:12] = 4'd0;
            end else begin
                next_q[15:12] = q[15:12] + 1'b1;
            end
        end
    end

    assign ena = next_ena;

endmodule
