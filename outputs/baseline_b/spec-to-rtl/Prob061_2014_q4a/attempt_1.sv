module TopModule (
    input logic clk,
    input logic w,
    input logic R,
    input logic E,
    input logic L,
    output logic Q
);

    logic next_Q;

    always_ff @(posedge clk) begin
        Q <= next_Q;
    end

    always_comb begin
        if (L) begin
            next_Q = R;
        end else if (E) begin
            next_Q = w;
        end else begin
            next_Q = Q;
        end
    end

endmodule
