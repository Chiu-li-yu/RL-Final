module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    logic [7:0] min_ab;
    logic [7:0] min_cd;

    always @(*) begin
        min_ab = (a < b) ? a : b;
        min_cd = (c < d) ? c : d;
        
        if (min_ab < min_cd)
            min = min_ab;
        else
            min = min_cd;
    end

endmodule
