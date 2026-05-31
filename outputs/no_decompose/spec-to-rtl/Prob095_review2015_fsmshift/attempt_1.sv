module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    logic [2:0] counter;
    logic ena_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;
            ena_reg <= 1'b1;
        end else begin
            if (counter < 3'd3) begin
                counter <= counter + 1'b1;
                ena_reg <= 1'b1;
            end else begin
                ena_reg <= 1'b0;
            end
        end
    end

    assign shift_ena = ena_reg;

endmodule
