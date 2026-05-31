module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    logic [3:0] A = 4'b0001;
    logic [3:0] B = 4'b0010;
    logic [3:0] C = 4'b0100;
    logic [3:0] D = 4'b1000;

    always @(*) begin
        case (state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A;
        endcase
    end

    assign out = (state == D);

endmodule