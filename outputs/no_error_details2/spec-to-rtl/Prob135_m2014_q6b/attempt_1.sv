module TopModule (
    input [2:0] y,
    input w,
    output Y1
);
    // State encoding:
    // A: 000, B: 001, C: 010, D: 011, E: 100, F: 101

    // State transition logic (y_next):
    // If w=0:
    // A(000) -> B(001)
    // B(001) -> C(010)
    // C(010) -> E(100)
    // D(011) -> F(101)
    // E(100) -> E(100)
    // F(101) -> C(010)

    // If w=1:
    // A(000) -> A(000)
    // B(001) -> D(011)
    // C(010) -> D(011)
    // D(011) -> A(000)
    // E(100) -> D(011)
    // F(101) -> D(011)

    logic y_next_1;

    always @(*) begin
        case (y)
            3'b000: y_next_1 = w ? 1'b0 : 1'b0; // A: w0=B(001), w1=A(000) -> y[1]=0, 0
            3'b001: y_next_1 = w ? 1'b1 : 1'b1; // B: w0=C(010), w1=D(011) -> y[1]=1, 1
            3'b010: y_next_1 = w ? 1'b1 : 1'b0; // C: w0=E(100), w1=D(011) -> y[1]=0, 1
            3'b011: y_next_1 = w ? 1'b0 : 1'b0; // D: w0=F(101), w1=A(000) -> y[1]=0, 0
            3'b100: y_next_1 = w ? 1'b1 : 1'b0; // E: w0=E(100), w1=D(011) -> y[1]=0, 1
            3'b101: y_next_1 = w ? 1'b1 : 1'b0; // F: w0=C(010), w1=D(011) -> y[1]=1, 1
            default: y_next_1 = 1'b0;
        endcase
    end

    assign Y1 = y_next_1;

endmodule
