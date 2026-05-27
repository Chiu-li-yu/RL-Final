module TopModule (
    input logic [2:0] in,
    output logic [1:0] out
);

    logic [1:0] count;

    always_comb begin
        count = 0;
        if (in[0]) count = count + 1;
        if (in[1]) count = count + 1;
        if (in[2]) count = count + 1;
    end

    assign out = count;

endmodule
