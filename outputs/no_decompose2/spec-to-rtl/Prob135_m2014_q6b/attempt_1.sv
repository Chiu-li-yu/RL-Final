module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // State Encoding:
    // A: 000
    // B: 001
    // C: 010
    // D: 011
    // E: 100
    // F: 101

    logic next_y1;

    always @(*) begin
        case (y)
            3'b000: next_y1 = w ? 1'b0 : 1'b0; // A --w--> A/B -> y1: 0/0
            3'b001: next_y1 = w ? 1'b1 : 1'b0; // B --w--> D/C -> y1: 1/0
            3'b010: next_y1 = w ? 1'b1 : 1'b0; // C --w--> D/E -> y1: 1/0
            3'b011: next_y1 = w ? 1'b0 : 1'b1; // D --w--> A/F -> y1: 0/1
            3'b100: next_y1 = w ? 1'b1 : 1'b0; // E --w--> D/E -> y1: 1/0
            3'b101: next_y1 = w ? 1'b1 : 1'b0; // F --w--> D/C -> y1: 1/0
            default: next_y1 = 1'b0;
        endcase
    end

    assign Y1 = next_y1;

endmodule
