module TopModule (
    input in,
    input [3:0] state,
    output logic [3:0] next_state,
    output logic out
);
    // State Encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // State Transition Logic
    always @(*) begin
        case (state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A;
        endcase
    end

    // Output Logic
    always @(*) begin
        out = (state == D);
    end
endmodule
