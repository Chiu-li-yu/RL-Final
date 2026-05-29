
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    localparam A = 2'd0;
    localparam B = 2'd1;
    localparam C = 2'd2;
    localparam D = 2'd3;

    logic [1:0] state, next_state;

    // State Transition Logic
    always @(*) begin
        case (state)
            A: begin
                if (in == 1'b0) next_state = A;
                else next_state = B;
            end
            B: begin
                if (in == 1'b0) next_state = C;
                else next_state = B;
            end
            C: begin
                if (in == 1'b0) next_state = A;
                else next_state = D;
            end
            D: begin
                if (in == 1'b0) next_state = C;
                else next_state = B;
            end
            default: next_state = A;
        endcase
    end

    // State Register
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Output Logic (Moore)
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
