module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    localparam OFF = 1'b0;
    localparam ON = 1'b1;

    logic state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            OFF: begin
                if (j == 1'b1)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            ON: begin
                if (k == 1'b1)
                    next_state = OFF;
                else
                    next_state = ON;
            end
            default: next_state = OFF;
        endcase
    end

    // Sequential logic for state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (Moore machine)
    assign out = (state == ON);

endmodule
