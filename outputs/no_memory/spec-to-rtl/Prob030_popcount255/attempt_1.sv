module TopModule (
    input  logic [254:0] in,
    output logic [7:0] out
);
    logic [8:0] count;
    integer i;

    always_comb begin
        count = 0;
        for (i = 0; i < 255; i = i + 1) begin
            if (in[i]) begin
                count = count + 1;
            end
        end
        out = count[7:0];
    end
endmodule