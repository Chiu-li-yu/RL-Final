
module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    localparam S0 = 2'd0; // Initial state
    localparam S1 = 2'd1; // Found '1'
    localparam S2 = 2'd2; // Found '10'

    logic [1:0] state, next_state;
    logic z_comb;

    // State register
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        next_state = state;
        z_comb = 1'b0;

        case (state)
            S0: begin
                if (x) begin
                    next_state = S1;
                end else begin
                    next_state = S0;
                end
            end
            S1: begin
                if (x) begin
                    next_state = S1;
                end else begin
                    next_state = S2;
                end
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z_comb = 1'b1; // Sequence "101" detected
                end else begin
                    next_state = S0;
                end
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    assign z = z_comb;

endmodule
