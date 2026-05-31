module TopModule(
    input a,
    input b,
    output out
);

    logic internal_xnor;
    always @(*) begin
        internal_xnor = ~(a ^ b);
    end

    assign out = internal_xnor;

endmodule