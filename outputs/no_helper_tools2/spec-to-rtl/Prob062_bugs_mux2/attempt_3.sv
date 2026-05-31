module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output logic out
);

    logic [7:0] mux_out;

    always @(*) begin
        if (sel)
            mux_out = b;
        else
            mux_out = a;
    end

    assign out = mux_out[0];

endmodule
