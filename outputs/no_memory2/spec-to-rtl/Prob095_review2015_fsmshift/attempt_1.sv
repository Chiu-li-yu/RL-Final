module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    logic [2:0] count;
    logic ena;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            ena <= 1'b1;
        end else if (count < 3'd3) begin
            count <= count + 1'b1;
            ena <= 1'b1;
        end else begin
            ena <= 1'b0;
        end
    end

    assign shift_ena = ena;

endmodule