module TopModule(
    input clk,
    input a,
    output logic q
);

    logic state;

    always @(posedge clk) begin
        if (state == 0) begin
            if (a == 0) state <= 1;
            else state <= 0;
        end else begin
            if (a == 1) state <= 0;
            else state <= 1;
        end
    end

    always @(*) begin
        q = state;
    end

endmodule