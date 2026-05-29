module TopModule (
    input      cpu_overheated,
    output logic shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output logic keep_driving
);

    always @(*) begin
        if (cpu_overheated)
            shut_off_computer = 1'b1;
        else
            shut_off_computer = 1'b0;
    end

    always @(*) begin
        if (~arrived)
            keep_driving = ~gas_tank_empty;
        else
            keep_driving = 1'b0;
    end

endmodule
