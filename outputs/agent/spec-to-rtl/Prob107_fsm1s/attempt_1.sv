module TopModule (
    input clk,
    input reset,
    input in,
    output out
);
    logic state; // B=1, A=0
    logic next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b1;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            1'b1: begin // B
                if (in) next_state = 1'b1;
                else next_state = 1'b0;
            end
            1'b0: begin // A
                if (in) next_state = 1'b0;
                else next_state = 1'b1;
            end
            default: next_state = 1'b1;
        endcase
    end

    assign out = (state == 1'b1);

endmodule
