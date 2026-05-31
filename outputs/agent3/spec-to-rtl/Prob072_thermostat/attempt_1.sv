module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    logic heater_w;
    logic aircon_w;
    logic fan_w;

    always @(*) begin
        if (mode == 1'b1) begin
            // Heating mode
            heater_w = too_cold;
            aircon_w = 1'b0;
        end else begin
            // Cooling mode
            heater_w = 1'b0;
            aircon_w = too_hot;
        end

        // Fan is on if heater is on, aircon is on, or fan_on is requested
        fan_w = heater_w || aircon_w || fan_on;
    end

    assign heater = heater_w;
    assign aircon = aircon_w;
    assign fan = fan_w;

endmodule
