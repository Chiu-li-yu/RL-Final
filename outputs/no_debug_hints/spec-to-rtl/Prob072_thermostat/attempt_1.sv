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

    always @(*) begin
        heater_out = 0;
        aircon_out = 0;
        fan_out = fan_on;

        if (mode == 1) begin
            // Heating mode
            if (too_cold) begin
                heater_out = 1;
                fan_out = 1;
            end
        end else begin
            // Cooling mode
            if (too_hot) begin
                aircon_out = 1;
                fan_out = 1;
            end
        end
    end

    assign heater = heater_out;
    assign aircon = aircon_out;
    assign fan = fan_out;

endmodule
