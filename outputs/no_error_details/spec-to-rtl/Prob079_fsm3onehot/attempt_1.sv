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

    logic [3:0] next_state_logic;
    logic out_logic;

    always @(*) begin
        case (state)
            A: next_state_logic = in ? B : A;
            B: next_state_logic = in ? B : C;
            C: next_state_logic = in ? D : A;
            D: next_state_logic = in ? B : C;
            default: next_state_logic = A;
        endcase
    end

    always @(*) begin
        out_logic = (state == D);
    end

    assign next_state = next_state_logic;
    assign out = out_logic;

endmodule