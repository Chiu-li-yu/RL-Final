module TopModule (
    input clock,
    input a,
    output logic p,
    output logic q
);

    always @(*) begin
        if (clock) begin
            p = a;
        end
    end

    always @(negedge clock) begin
        q <= p;
    end

endmodule
