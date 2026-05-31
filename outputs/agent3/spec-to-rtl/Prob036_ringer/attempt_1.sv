module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    logic ringer_val;
    logic motor_val;

    always @(*) begin
        if (ring) begin
            if (vibrate_mode) begin
                ringer_val = 1'b0;
                motor_val = 1'b1;
            end else begin
                ringer_val = 1'b1;
                motor_val = 1'b0;
            end
        end else begin
            ringer_val = 1'b0;
            motor_val = 1'b0;
        end
    end

    assign ringer = ringer_val;
    assign motor = motor_val;

endmodule