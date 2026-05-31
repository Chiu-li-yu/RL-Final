module TopModule (
    input in,
    input [3:0] state,
    output logic [3:0] next_state,
    output logic out
);

    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    always @(*) begin
        case (state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A;
        endcase
    end

    always @(*) begin
        out = (state == D);
    end

endmodule