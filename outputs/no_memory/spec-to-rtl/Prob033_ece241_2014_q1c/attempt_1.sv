module TopModule (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    logic [8:0] temp;

    always @(*) begin
        temp = {a[7], a} + {b[7], b};
    end

    assign s = temp[7:0];
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
endmodule
