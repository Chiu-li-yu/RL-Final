module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    logic state;
    logic next_state;

    parameter A = 1'b0;
    parameter B = 1'b1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            B: begin
                if (in) next_state = B;
                else next_state = A;
            end
            A: begin
                if (in) next_state = A;
                else next_state = B;
            end
            default: next_state = B;
        endcase
    end

    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule
