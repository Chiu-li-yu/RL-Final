
module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    logic [15:0] q_reg;

    // BCD Counter Logic
    always @(posedge clk) begin
        if (reset) begin
            q_reg <= 16'd0;
        end else begin
            // Ones digit: always increments unless reset
            if (q_reg[3:0] == 4'd9) begin
                q_reg[3:0] <= 4'd0;
            end else begin
                q_reg[3:0] <= q_reg[3:0] + 4'd1;
            end

            // Tens digit: increments when ones digit is 9
            if (q_reg[3:0] == 4'd9) begin
                if (q_reg[7:4] == 4'd9) begin
                    q_reg[7:4] <= 4'd0;
                end else begin
                    q_reg[7:4] <= q_reg[7:4] + 4'd1;
                end
            end

            // Hundreds digit: increments when tens digit is 9 AND ones digit is 9
            if ((q_reg[7:4] == 4'd9) && (q_reg[3:0] == 4'd9)) begin
                if (q_reg[11:8] == 4'd9) begin
                    q_reg[11:8] <= 4'd0;
                end else begin
                    q_reg[11:8] <= q_reg[11:8] + 4'd1;
                end
            end

            // Thousands digit: increments when hundreds digit is 9 AND tens digit is 9 AND ones digit is 9
            if ((q_reg[11:8] == 4'd9) && (q_reg[7:4] == 4'd9) && (q_reg[3:0] == 4'd9)) begin
                if (q_reg[15:12] == 4'd9) begin
                    q_reg[15:12] <= 4'd0;
                end else begin
                    q_reg[15:12] <= q_reg[15:12] + 4'd1;
                end
            end
        end
    end

    // Enable signals for upper digits
    // ena[0]: enable for tens digit (q[7:4])
    // ena[1]: enable for hundreds digit (q[11:8])
    // ena[2]: enable for thousands digit (q[15:12])
    assign ena[0] = (q_reg[3:0] == 4'd9);
    assign ena[1] = (q_reg[7:4] == 4'd9) && (q_reg[3:0] == 4'd9);
    assign ena[2] = (q_reg[11:8] == 4'd9) && (q_reg[7:4] == 4'd9) && (q_reg[3:0] == 4'd9);

    assign q = q_reg;

endmodule
