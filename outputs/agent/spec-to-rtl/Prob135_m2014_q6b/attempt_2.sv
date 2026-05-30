module TopModule(
    input  logic [2:0] y,
    input  logic       w,
    output logic       Y1
);

    logic [2:0] next_y;

    // A=000, B=001, C=010, D=011, E=100, F=101
    always_comb begin
        case (y)
            3'b000: next_y = w ? 3'b000 : 3'b001; // A
            3'b001: next_y = w ? 3'b011 : 3'b010; // B
            3'b010: next_y = w ? 3'b011 : 3'b100; // C
            3'b011: next_y = w ? 3'b000 : 3'b101; // D
            3'b100: next_y = w ? 3'b011 : 3'b100; // E
            3'b101: next_y = w ? 3'b011 : 3'b010; // F
            default: next_y = 3'b000;
        endcase
    end

    // The question asks for the next-state logic for y[1].
    // Given the question asks for TopModule with input y[2:0], 
    // it seems the input y is actually the *current state*.
    // And I need to output Y1 = (next_state)[1].
    
    assign Y1 = next_y[1];

endmodule