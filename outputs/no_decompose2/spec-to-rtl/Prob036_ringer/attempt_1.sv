module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    logic ringer_int;
    logic motor_int;

    always @(*) begin
        if (ring) begin
            if (vibrate_mode) begin
                ringer_int = 1'b0;
                motor_int = 1'b1;
            end else begin
                ringer_int = 1'b1;
                motor_int = 1'b0;
            end
        end else begin
            ringer_int = 1'b0;
            motor_int = 1'b0;
        end
    end

    assign ringer = ringer_int;
    assign motor = motor_int;

endmodule