module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output logic out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    logic state;
    logic next_state;

    // State transition logic (Combinational)
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
            default: begin
                next_state = OFF;
            end
        endcase
    end

    // State register (Sequential with Asynchronous Reset)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    // Moore output logic (Combinational)
    always @(*) begin
        if (state == ON)
            out = 1'b1;
        else
            out = 1'b0;
    end

endmodule
