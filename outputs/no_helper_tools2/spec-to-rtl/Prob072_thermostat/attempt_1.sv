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
        // Mode 1: Heating, Mode 0: Cooling
        if (mode == 1'b1) begin
            // Heating mode
            heater = too_cold;
            aircon = 1'b0;
        end else begin
            // Cooling mode
            heater = 1'b0;
            aircon = too_hot;
        end
        
        // Fan is on if heater is on, aircon is on, or fan_on is requested
        fan = heater || aircon || fan_on;
    end

endmodule