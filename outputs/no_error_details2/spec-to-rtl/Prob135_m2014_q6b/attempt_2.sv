module TopModule (
    input [2:0] y,
    input w,
    output Y1
);
    // State encoding:
    // A: 000, B: 001, C: 010, D: 011, E: 100, F: 101

    // Logic for next_state_1 (the second bit of the state):
    // Current state (y) -> Next state (y_next)
    // A (000) --0--> B (001)  : y_next = 001, y_next[1] = 0
    // A (000) --1--> A (000)  : y_next = 000, y_next[1] = 0
    // B (001) --0--> C (010)  : y_next = 010, y_next[1] = 1
    // B (001) --1--> D (011)  : y_next = 011, y_next[1] = 1
    // C (010) --0--> E (100)  : y_next = 100, y_next[1] = 0
    // C (010) --1--> D (011)  : y_next = 011, y_next[1] = 1
    // D (011) --0--> F (101)  : y_next = 101, y_next[1] = 0
    // D (011) --1--> A (000)  : y_next = 000, y_next[1] = 0
    // E (100) --0--> E (100)  : y_next = 100, y_next[1] = 0
    // E (100) --1--> D (011)  : y_next = 011, y_next[1] = 1
    // F (101) --0--> C (010)  : y_next = 010, y_next[1] = 1
    // F (101) --1--> D (011)  : y_next = 011, y_next[1] = 1

    logic y_next_1;

    always @(*) begin
        case (y)
            3'b000: y_next_1 = 1'b0; // A: w=0->0, w=1->0
            3'b001: y_next_1 = 1'b1; // B: w=0->1, w=1->1
            3'b010: y_next_1 = w ? 1'b1 : 1'b0; // C: w=0->0, w=1->1
            3'b011: y_next_1 = 1'b0; // D: w=0->0, w=1->0
            3'b100: y_next_1 = w ? 1'b1 : 1'b0; // E: w=0->0, w=1->1
            3'b101: y_next_1 = 1'b1; // F: w=0->1, w=1->1
            default: y_next_1 = 1'b0;
        endcase
    end

    assign Y1 = y_next_1;

endmodule
