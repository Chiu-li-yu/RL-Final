module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    always @(*) begin
        // Heating mode (mode = 1): turn on heater if too cold, aircon always off.
        // Cooling mode (mode = 0): turn on aircon if too hot, heater always off.
        if (mode == 1'b1) begin
            heater = too_cold;
            aircon = 1'b0;
        end else begin
            heater = 1'b0;
            aircon = too_hot;
        end

        // Fan turns on if heater is on, aircon is on, or user requests fan_on.
        if (heater == 1'b1 || aircon == 1'b1 || fan_on == 1'b1) begin
            fan = 1'b1;
        end else begin
            fan = 1'b0;
        end
    end

endmodule
