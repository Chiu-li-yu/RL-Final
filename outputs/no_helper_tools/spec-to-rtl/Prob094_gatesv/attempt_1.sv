module TopModule(
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    logic [3:0] out_both_int;
    logic [3:0] out_any_int;
    logic [3:0] out_different_int;

    always @(*) begin
        // out_both: in[i] & in[i+1]
        // out_both[3] is don't care (spec says "don't need to know")
        out_both_int[0] = in[0] & in[1];
        out_both_int[1] = in[1] & in[2];
        out_both_int[2] = in[2] & in[3];
        out_both_int[3] = 1'b0; 

        // out_any: in[i] | in[i-1]
        // out_any[0] is don't care
        out_any_int[0] = 1'b0;
        out_any_int[1] = in[1] | in[0];
        out_any_int[2] = in[2] | in[1];
        out_any_int[3] = in[3] | in[2];

        // out_different: in[i] ^ in[i+1] (with wrap around)
        out_different_int[0] = in[0] ^ in[1];
        out_different_int[1] = in[1] ^ in[2];
        out_different_int[2] = in[2] ^ in[3];
        out_different_int[3] = in[3] ^ in[0];
    end

    assign out_both = out_both_int;
    assign out_any = out_any_int;
    assign out_different = out_different_int;

endmodule