module TopModule (
    input clk,
    input reset,
    input in,
    output logic out
);

    localparam B = 1'b0;
    localparam A = 1'b1;

    logic state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            B: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            A: begin
                if (in == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            end
            default: next_state = B;
        endcase
    end

    // Output logic (Moore machine)
    always @(*) begin
        case (state)
            B: out = 1'b1;
            A: out = 1'b0;
            default: out = 1'b1;
        endcase
    end

endmodule
