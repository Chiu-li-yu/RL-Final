module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    // States: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
    logic A, B, C, D;
    assign {D, C, B, A} = state;

    logic next_A, next_B, next_C, next_D;

    always @(*) begin
        // State transition logic
        // A -> (in=0)? A : B
        // B -> (in=0)? C : B
        // C -> (in=0)? A : D
        // D -> (in=0)? C : B
        
        next_A = (A & ~in) | (C & ~in);
        next_B = (A & in) | (B & in) | (D & in);
        next_C = (B & ~in) | (D & ~in);
        next_D = (C & in);
    end

    assign next_state = {next_D, next_C, next_B, next_A};
    assign out = (state == 4'b1000); // Only D outputs 1

endmodule
