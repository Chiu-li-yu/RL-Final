module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    logic [7:0] min_ab;
    logic [7:0] min_cd;
    logic [7:0] min_final;

    always @(*) begin
        if (a < b) begin
            min_ab = a;
        end else begin
            min_ab = b;
        end

        if (c < d) begin
            min_cd = c;
        end else begin
            min_cd = d;
        end

        if (min_ab < min_cd) begin
            min_final = min_ab;
        end else begin
            min_final = min_cd;
        end
    end

    assign min = min_final;

endmodule
