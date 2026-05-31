module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output logic [7:0] out
);

    always @(*) begin
        if (sel)
            out = a; // Swapped a and b based on typical mux definition
        else
            out = b;
    end

endmodule
