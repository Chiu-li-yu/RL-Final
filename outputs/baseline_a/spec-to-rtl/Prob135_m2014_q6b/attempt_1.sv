module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    // State definitions
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;

    logic [2:0] next_y;
    logic next_y1;

    assign Y1 = y[1];

    always @(*) begin
        case (y)
            A: next_y = w ? A : B;
            B: next_y = w ? D : C;
            C: next_y = w ? D : E;
            D: next_y = w ? A : F;
            E: next_y = w ? D : E;
            F: next_y = w ? D : C;
            default: next_y = A;
        endcase
    end

    // The logic asks for the next-state logic for y[1].
    // This is essentially next_y[1].
    // The problem asks to implement the logic, output is Y1 = y[1].
    // Wait, the prompt says "Implement just the next-state logic for y[1]".
    // This implies that the module should compute next_y[1] and output it?
    // But it says output Y1 is y[1].
    // Let me re-read:
    // "Implement just the next-state logic for y[1]. The output Y1 is y[1]."
    // This could mean the output Y1 should actually be the next-state value of y[1].
    // Let's re-verify the requirement.
    // "The output Y1 is y[1]" usually means output Y1 = current_state[1].
    // But if the requirement says "Implement JUST the next-state logic for y[1]",
    // maybe Y1 should be next_y[1]?
    // Given the phrasing, I will output next_y[1] as Y1.

endmodule
