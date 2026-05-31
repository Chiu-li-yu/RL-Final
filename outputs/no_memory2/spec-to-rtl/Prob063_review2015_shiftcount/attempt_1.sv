module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output logic [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift right: new data enters at MSB (bit 3)
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Down counter
            q <= q - 1'b1;
        end
    end

endmodule