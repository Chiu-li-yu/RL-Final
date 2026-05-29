module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output logic Q
);

    always @(posedge clk) begin
        if (L) begin
            Q <= R;
        end else if (E) begin
            Q <= w;
        end
    end

endmodule
