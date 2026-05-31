module TopModule (
    input [2:0] y,
    input w,
    output Y1
);
    // State assignments (as per problem description):
    // A: 000, B: 001, C: 010, D: 011, E: 100, F: 101

    // State definitions:
    // A=0, B=1, C=2, D=3, E=4, F=5

    // Next state (next_y) logic based on FSM:
    // A (000) --w=0--> B (001)
    // A (000) --w=1--> A (000)
    // B (001) --w=0--> C (010)
    // B (001) --w=1--> D (011)
    // C (010) --w=0--> E (100)
    // C (010) --w=1--> D (011)
    // D (011) --w=0--> F (101)
    // D (011) --w=1--> A (000)
    // E (100) --w=0--> E (100)
    // E (100) --w=1--> D (011)
    // F (101) --w=0--> C (010)
    // F (101) --w=1--> D (011)

    logic [2:0] next_y;

    always @(*) begin
        case (y)
            3'b000: next_y = (w == 1'b0) ? 3'b001 : 3'b000;
            3'b001: next_y = (w == 1'b0) ? 3'b010 : 3'b011;
            3'b010: next_y = (w == 1'b0) ? 3'b100 : 3'b011;
            3'b011: next_y = (w == 1'b0) ? 3'b101 : 3'b000;
            3'b100: next_y = (w == 1'b0) ? 3'b100 : 3'b011;
            3'b101: next_y = (w == 1'b0) ? 3'b010 : 3'b011;
            default: next_y = 3'b000;
        endcase
    end

    // The question asks for: "Implement just the next-state logic for y[1]. The output Y1 is y[1]."
    // Actually, based on standard FSM coding styles, if the module receives y as input
    // and asks to output Y1, Y1 is simply the middle bit of the next state logic.
    
    assign Y1 = next_y[1];

endmodule