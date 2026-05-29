module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    localparam B = 1'b0;
    localparam A = 1'b1;

    logic state, next_state;

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

    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    assign out = (state == B);

endmodule
