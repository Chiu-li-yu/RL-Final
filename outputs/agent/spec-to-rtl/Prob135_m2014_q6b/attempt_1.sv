module TopModule (
    input [2:0] y,
    input w,
    output logic Y1
);
    always @(*) begin
        case (y)
            3'b000: Y1 = 1'b0; // State A: next is B(001) or A(000), both y[1]=0
            3'b001: Y1 = 1'b1; // State B: next is C(010) or D(011), both y[1]=1
            3'b010: Y1 = w;    // State C: next is E(100) [y[1]=0] if w=0, D(011) [y[1]=1] if w=1
            3'b011: Y1 = 1'b0; // State D: next is F(101) [y[1]=0] or A(000) [y[1]=0]
            3'b100: Y1 = w;    // State E: next is E(100) [y[1]=0] if w=0, D(011) [y[1]=1] if w=1
            3'b101: Y1 = 1'b1; // State F: next is C(010) [y[1]=1] or D(011) [y[1]=1]
            default: Y1 = 1'b0;
        endcase
    end
endmodule
