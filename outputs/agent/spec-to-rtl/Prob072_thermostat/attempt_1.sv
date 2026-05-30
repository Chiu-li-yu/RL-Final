module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    logic heater_out;
    logic aircon_out;
    logic fan_out;

    assign heater = heater_out;
    assign aircon = aircon_out;
    assign fan = fan_out;

    always @(*) begin
        if (mode == 1'b1) begin
            // Heating mode
            heater_out = too_cold;
            aircon_out = 1'b0;
        end else begin
            // Cooling mode
            heater_out = 1'b0;
            aircon_out = too_hot;
        end
        
        fan_out = (heater_out || aircon_out || fan_on);
    end

endmodule
