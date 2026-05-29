module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;
    logic state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            STATE_A: begin
                if (in == 1'b0)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end
            STATE_B: begin
                if (in == 1'b0)
                    next_state = STATE_A;
                else
                    next_state = STATE_B;
            end
            default: next_state = STATE_B;
        endcase
    end

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_B;
        end else begin
            state <= next_state;
        end
    end

    // Moore output logic
    always @(*) begin
        if (state == STATE_B)
            out = 1'b1;
        else
            out = 1'b0;
    end

endmodule
