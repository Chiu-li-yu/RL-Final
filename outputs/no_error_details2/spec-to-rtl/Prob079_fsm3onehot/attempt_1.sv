module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);
    // State encoding: A=0001, B=0010, C=0100, D=1000
    // State transition table:
    // State | Next (in=0) | Next (in=1) | Output
    // A     | A           | B           | 0
    // B     | C           | B           | 0
    // C     | A           | D           | 0
    // D     | C           | B           | 1

    logic [3:0] next_state_logic;
    logic out_logic;

    assign next_state = next_state_logic;
    assign out = out_logic;

    always @(*) begin
        case (state)
            4'b0001: begin // A
                if (in) next_state_logic = 4'b0010; // B
                else    next_state_logic = 4'b0001; // A
                out_logic = 1'b0;
            end
            4'b0010: begin // B
                if (in) next_state_logic = 4'b0010; // B
                else    next_state_logic = 4'b0100; // C
                out_logic = 1'b0;
            end
            4'b0100: begin // C
                if (in) next_state_logic = 4'b1000; // D
                else    next_state_logic = 4'b0001; // A
                out_logic = 1'b0;
            end
            4'b1000: begin // D
                if (in) next_state_logic = 4'b0010; // B
                else    next_state_logic = 4'b0100; // C
                out_logic = 1'b1;
            end
            default: begin
                next_state_logic = 4'b0001;
                out_logic = 1'b0;
            end
        endcase
    end
endmodule
