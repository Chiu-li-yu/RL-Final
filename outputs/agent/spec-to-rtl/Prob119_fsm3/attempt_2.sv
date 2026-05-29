
module TopModule (
    input clk,
    input areset,
    input in,
    output logic out
);

    localparam A = 2'd0;
    localparam B = 2'd1;
    localparam C = 2'd2;
    localparam D = 2'd3;

    logic [1:0] state, next_state;

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A;
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        case (state)
            A: out = 1'b0;
            B: out = 1'b0;
            C: out = 1'b0;
            D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule
