module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    logic heater_int;
    logic aircon_int;
    logic fan_int;

    always @(*) begin
        heater_int = 0;
        aircon_int = 0;
        fan_int = fan_on;

        if (mode == 1) begin
            // Heating mode
            if (too_cold) begin
                heater_int = 1;
                fan_int = 1;
            end
        end else begin
            // Cooling mode
            if (too_hot) begin
                aircon_int = 1;
                fan_int = 1;
            end
        end
    end

    assign heater = heater_int;
    assign aircon = aircon_int;
    assign fan = fan_int;

endmodule
