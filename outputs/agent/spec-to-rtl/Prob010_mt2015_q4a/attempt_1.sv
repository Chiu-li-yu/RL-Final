module TopModule (
    input x,
    input y,
    output z
);

    logic z_val;
    assign z_val = (x ^ y) & x;
    
    always @(*) begin
        z = z_val;
    end

endmodule