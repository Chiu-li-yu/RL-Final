module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    logic state;
    logic next_state;

    // Output logic (Moore machine: output depends only on state)
    assign out = (state == ON);

    // Next state logic
    always @(*) begin
        case (state)
            OFF: begin
                if (j) next_state = ON;
                else   next_state = OFF;
            end
            ON: begin
                if (k) next_state = OFF;
                else   next_state = ON;
            end
            default: next_state = OFF;
        endcase
    end

    // Sequential logic (Synchronous reset)
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

endmodule
