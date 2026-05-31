module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);

    assign out_assign = (sel_b1 && sel_b2) ? b : a;

    logic out_always_temp;
    always @(*) begin
        if (sel_b1 && sel_b2) begin
            out_always_temp = b;
        end else begin
            out_always_temp = a;
        end
    end

    assign out_always = out_always_temp;

endmodule
