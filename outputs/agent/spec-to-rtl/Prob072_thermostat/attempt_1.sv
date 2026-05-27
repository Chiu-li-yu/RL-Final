module TopModule (
    input logic mode,
    input logic too_cold,
    input logic too_hot,
    input logic fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    always @(*) begin
        // Heating mode (mode = 1)
        if (mode == 1'b1) begin
            heater = too_cold;
            aircon = 1'b0;
            fan = (too_cold | fan_on);
        end
        // Cooling mode (mode = 0)
        else begin
            heater = 1'b0;
            aircon = too_hot;
            fan = (too_hot | fan_on);
        end
    end

endmodule
