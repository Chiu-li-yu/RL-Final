module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);
    // State encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // State transition logic
    // A=0001, B=0010, C=0100, D=1000
    // A: in=0 -> A (0001), in=1 -> B (0010)
    // B: in=0 -> C (0100), in=1 -> B (0010)
    // C: in=0 -> A (0001), in=1 -> D (1000)
    // D: in=0 -> C (0100), in=1 -> B (0010)

    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Output logic
    // Moore machine: Output depends only on current state
    // A: 0, B: 0, C: 0, D: 1
    assign out = (state == D);
endmodule
