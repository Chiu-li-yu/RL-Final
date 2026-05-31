module TopModule (
    input  logic [254:0] in,
    output logic [7:0]   out
);
    logic [7:0] count;
    integer i;

    always @(*) begin
        count = 8'd0;
        for (i = 0; i < 255; i = i + 1) begin
            if (in[i]) begin
                count = count + 1'b1;
            end
        end
    end

    assign out = count;
endmodule
