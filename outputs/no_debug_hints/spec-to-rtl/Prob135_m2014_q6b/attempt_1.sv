module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

// State mapping:
// A: 000
// B: 001
// C: 010
// D: 011
// E: 100
// F: 101

// Y1 is defined as y[1]
assign Y1 = y[1];

// We need to implement the next-state logic for y[1].
// However, the prompt asks to "Implement just the next-state logic for y[1]".
// And the output Y1 is y[1]. 
// Wait, the prompt says "Implement just the next-state logic for y[1]" but 
// usually, a state machine needs to output the next state.
// Looking at the prompt again: "The module should implement the state machine... 
// Implement just the next-state logic for y[1]."
// This is slightly ambiguous. Does it mean I only need to output the *next* state 
// of bit y[1] as Y1?
// Let's re-read: "output Y1. The module should implement the state machine...
// The output Y1 is y[1]."
// This implies Y1 = current_state[1].
// If the question meant "calculate the next state bit 1", it would usually 
// ask for an output like 'next_y1'.
// Since it asks for Y1 = y[1], and I am given y as an input, 
// maybe I just need to perform the mapping?
// But the prompt says "The module should implement the state machine... 
// Implement just the next-state logic for y[1]". 
// This suggests I need to calculate the *next* y[1] value based on current y and w.
// Let's call the next state Y_next.
// Y_next[1] is the function of (y, w).
// The output Y1 should be Y_next[1].

// Let's map out the transitions to find next state (Y_next):
// Current | w=0 | w=1
// A(000)  | B(001) | A(000)
// B(001)  | C(010) | D(011)
// C(010)  | E(100) | D(011)
// D(011)  | F(101) | A(000)
// E(100)  | E(100) | D(011)
// F(101)  | C(010) | D(011)

// Now find next_y[1] (the second bit of the next state):
// Current | w=0 | w=1
// A(000)  | 0   | 0
// B(001)  | 1   | 1
// C(010)  | 0   | 1
// D(011)  | 0   | 0
// E(100)  | 0   | 1
// F(101)  | 1   | 1

// Truth table for next_y[1] (y2, y1, y0, w):
// y2 y1 y0 w | next_y1
// 0  0  0  0 | 0
// 0  0  0  1 | 0
// 0  0  1  0 | 1
// 0  0  1  1 | 1
// 0  1  0  0 | 0
// 0  1  0  1 | 1
// 0  1  1  0 | 0
// 0  1  1  1 | 0
// 1  0  0  0 | 0
// 1  0  0  1 | 1
// 1  0  1  0 | 1
// 1  0  1  1 | 1

logic next_y1;
always @(*) begin
    case ({y, w})
        4'b0000: next_y1 = 0;
        4'b0001: next_y1 = 0;
        4'b0010: next_y1 = 1;
        4'b0011: next_y1 = 1;
        4'b0100: next_y1 = 0;
        4'b0101: next_y1 = 1;
        4'b0110: next_y1 = 0;
        4'b0111: next_y1 = 0;
        4'b1000: next_y1 = 0;
        4'b1001: next_y1 = 1;
        4'b1010: next_y1 = 1;
        4'b1011: next_y1 = 1;
        default: next_y1 = 0;
    endcase
end

assign Y1 = next_y1;

endmodule
