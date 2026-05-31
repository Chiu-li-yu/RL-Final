module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

    // Using 3 states: 
    // S0: Initial state / reset state
    // S1: Saw '1'
    // S2: Saw '10'
    logic [1:0] state, next_state;
    logic z_out;

    parameter S0 = 2'd0;
    parameter S1 = 2'd1;
    parameter S2 = 2'd2;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = S0;
        z_out = 1'b0;
        case (state)
            S0: begin
                if (x) next_state = S1;
                else   next_state = S0;
            end
            S1: begin
                if (x) next_state = S1;
                else   next_state = S2;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z_out = 1'b1; // Sequence 101 detected
                end else begin
                    next_state = S0;
                end
            end
        endcase
    end

    assign z = z_out;

endmodule
