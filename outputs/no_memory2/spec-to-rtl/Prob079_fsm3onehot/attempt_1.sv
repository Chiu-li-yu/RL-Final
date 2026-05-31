module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot encoding
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    logic [3:0] next_state_logic;
    logic out_logic;

    always @(*) begin
        case (state)
            A: begin
                next_state_logic = in ? B : A;
                out_logic = 0;
            end
            B: begin
                next_state_logic = in ? B : C;
                out_logic = 0;
            end
            C: begin
                next_state_logic = in ? D : A;
                out_logic = 0;
            end
            D: begin
                next_state_logic = in ? B : C;
                out_logic = 1;
            end
            default: begin
                next_state_logic = A;
                out_logic = 0;
            end
        endcase
    end

    assign next_state = next_state_logic;
    assign out = out_logic;

endmodule
