module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // State Encoding:
    // A (000) --0--> B (001)
    // A (000) --1--> A (000)
    // B (001) --0--> C (010)
    // B (001) --1--> D (011)
    // C (010) --0--> E (100)
    // C (010) --1--> D (011)
    // D (011) --0--> F (101)
    // D (011) --1--> A (000)
    // E (100) --0--> E (100)
    // E (100) --1--> D (011)
    // F (101) --0--> C (010)
    // F (101) --1--> D (011)

    // Next state logic:
    // next_y = f(y, w)
    // A: 000, B: 001, C: 010, D: 011, E: 100, F: 101

    logic [2:0] next_y;

    always @(*) begin
        case (y)
            3'b000: next_y = w ? 3'b000 : 3'b001;
            3'b001: next_y = w ? 3'b011 : 3'b010;
            3'b010: next_y = w ? 3'b011 : 3'b100;
            3'b011: next_y = w ? 3'b000 : 3'b101;
            3'b100: next_y = w ? 3'b011 : 3'b100;
            3'b101: next_y = w ? 3'b011 : 3'b010;
            default: next_y = 3'b000;
        endcase
    end

    // The output Y1 is the second bit (y[1]) of the next state
    assign Y1 = next_y[1];

endmodule
