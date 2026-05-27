module TopModule (
    input logic in,
    input logic [3:0] state,
    output logic [3:0] next_state,
    output logic out
);

    // One-hot encoding definitions
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    always_comb begin
        // Default assignment
        next_state = 4'b0000;
        out = 1'b0;

        case (state)
            A: begin
                out = 1'b0;
                if (in) next_state = B;
                else    next_state = A;
            end
            B: begin
                out = 1'b0;
                if (in) next_state = B;
                else    next_state = C;
            end
            C: begin
                out = 1'b0;
                if (in) next_state = D;
                else    next_state = A;
            end
            D: begin
                out = 1'b1;
                if (in) next_state = B;
                else    next_state = C;
            end
            default: begin
                next_state = A;
                out = 1'b0;
            end
        endcase
    end
endmodule
