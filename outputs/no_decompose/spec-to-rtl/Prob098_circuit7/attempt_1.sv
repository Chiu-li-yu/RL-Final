module TopModule(
    input clk,
    input a,
    output logic q
);

    logic q_next;

    always_ff @(posedge clk) begin
        if (a == 0) begin
            q <= 1;
        end else begin
            q <= ~q;
        end
    end

endmodule
