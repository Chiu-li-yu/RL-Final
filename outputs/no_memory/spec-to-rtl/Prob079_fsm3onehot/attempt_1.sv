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

    logic [3:0] next_s;
    logic o;

    assign next_state = next_s;
    assign out = o;

    always @(*) begin
        case (state)
            A: begin
                if (in) next_s = B;
                else    next_s = A;
                o = 0;
            end
            B: begin
                if (in) next_s = B;
                else    next_s = C;
                o = 0;
            end
            C: begin
                if (in) next_s = D;
                else    next_s = A;
                o = 0;
            end
            D: begin
                if (in) next_s = B;
                else    next_s = C;
                o = 1;
            end
            default: begin
                next_s = A;
                o = 0;
            end
        endcase
    end
endmodule
