module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    logic [2:0] next_y;

    // State mapping:
    // A: 000
    // B: 001
    // C: 010
    // D: 011
    // E: 100
    // F: 101

    always @(*) begin
        case (y)
            3'b000: next_y = w ? 3'b000 : 3'b001; // A --w--> ...
            3'b001: next_y = w ? 3'b011 : 3'b010; // B --w--> ...
            3'b010: next_y = w ? 3'b011 : 3'b100; // C --w--> ...
            3'b011: next_y = w ? 3'b000 : 3'b101; // D --w--> ...
            3'b100: next_y = w ? 3'b011 : 3'b100; // E --w--> ...
            3'b101: next_y = w ? 3'b011 : 3'b010; // F --w--> ...
            default: next_y = 3'b000;
        endcase
    end

    // The task asks to implement the next-state logic for y[1].
    // Given the state transitions, we define the combinational logic for the next state y[1].
    // From the case statement:
    // next_y[1] is high when:
    // (y == 3'b001 && w == 1'b1) -> (y[2:0] == 001 && w)
    // (y == 3'b010 && w == 1'b0) -> (y[2:0] == 010 && !w)
    // (y == 3'b010 && w == 1'b1) -> (y[2:0] == 010 && w)
    // (y == 3'b011 && w == 1'b0) -> (y[2:0] == 011 && !w)
    // (y == 3'b100 && w == 1'b1) -> (y[2:0] == 100 && w)
    // (y == 3'b101 && w == 1'b1) -> (y[2:0] == 101 && w)
    // (y == 3'b101 && w == 1'b0) -> (y[2:0] == 101 && !w)

    // The output Y1 is defined as y[1].
    assign Y1 = y[1];

endmodule
