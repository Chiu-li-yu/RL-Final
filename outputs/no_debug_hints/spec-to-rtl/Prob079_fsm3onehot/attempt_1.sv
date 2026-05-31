module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);
    // State Encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // State Transition Logic
    logic [3:0] next_s;
    always @(*) begin
        case (state)
            A: next_s = (in) ? B : A;
            B: next_s = (in) ? B : C;
            C: next_s = (in) ? D : A;
            D: next_s = (in) ? B : C;
            default: next_s = A;
        endcase
    end

    // Output Logic
    logic o;
    always @(*) begin
        o = (state == D);
    end

    assign next_state = next_s;
    assign out = o;
endmodule
