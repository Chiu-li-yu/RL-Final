module TopModule (
    input [2:0] y,
    input w,
    output Y1
);
    // Y1 is defined as y[1] based on the specification
    assign Y1 = y[1];

    // Current states:
    // A: 000, B: 001, C: 010, D: 011, E: 100, F: 101

    // Next State Logic for y[1]:
    // Transitions (from y[2:0] to next_y[2:0]):
    // A (000) --0--> B (001) : next_y[1] = 0
    // A (000) --1--> A (000) : next_y[1] = 0
    // B (001) --0--> C (010) : next_y[1] = 1
    // B (001) --1--> D (011) : next_y[1] = 1
    // C (010) --0--> E (100) : next_y[1] = 0
    // C (010) --1--> D (011) : next_y[1] = 1
    // D (011) --0--> F (101) : next_y[1] = 0
    // D (011) --1--> A (000) : next_y[1] = 0
    // E (100) --0--> E (100) : next_y[1] = 0
    // E (100) --1--> D (011) : next_y[1] = 1
    // F (101) --0--> C (010) : next_y[1] = 1
    // F (101) --1--> D (011) : next_y[1] = 1

    logic next_y1;
    always @(*) begin
        case (y)
            3'b000: next_y1 = 0;
            3'b001: next_y1 = 1;
            3'b010: next_y1 = (~w); // C: w=0 -> E(100), w=1 -> D(011)
            3'b011: next_y1 = 0;
            3'b100: next_y1 = w;    // E: w=0 -> E(100), w=1 -> D(011)
            3'b101: next_y1 = 1;
            default: next_y1 = 0;
        endcase
    end
endmodule
