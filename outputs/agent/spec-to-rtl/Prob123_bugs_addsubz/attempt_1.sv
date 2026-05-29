module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    always @(*) begin
        case (do_sub)
            1'b0: out = a + b;
            1'b1: out = a - b;
            default: out = a + b;
        endcase

        if (out == 8'd0) begin
            result_is_zero = 1'b1;
        end else begin
            result_is_zero = 1'b0;
        end
    end

endmodule
