module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;
    logic state;
    logic next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            OFF: begin
                if (j) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            ON: begin
                if (k) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
            default: next_state = OFF;
        endcase
    end

    always @(*) begin
        if (state == ON) begin
            out = 1'b1;
        end else begin
            out = 1'b0;
        end
    end

endmodule
