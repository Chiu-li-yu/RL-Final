module TopModule(
    input clk,
    input reset,
    input in,
    output out
);
    logic state; // B=1, A=0
    logic next_state;

    always_ff @(posedge clk) begin
        if (reset)
            state <= 1'b1; // B
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            1'b1: // B
                if (in == 1'b0) next_state = 1'b0; // to A
                else next_state = 1'b1;            // to B
            1'b0: // A
                if (in == 1'b0) next_state = 1'b1; // to B
                else next_state = 1'b0;            // to A
            default: next_state = 1'b1;
        endcase
    end

    assign out = (state == 1'b1);
endmodule
