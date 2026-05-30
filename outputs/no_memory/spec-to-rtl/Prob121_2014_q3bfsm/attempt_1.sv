module TopModule (
    input clk,
    input reset,
    input x,
    output logic z
);
    logic [2:0] state, next_state;

    // Define states
    parameter S000 = 3'b000;
    parameter S001 = 3'b001;
    parameter S010 = 3'b010;
    parameter S011 = 3'b011;
    parameter S100 = 3'b100;

    // Sequential logic for state transition
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S000;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for next_state and output
    always_comb begin
        case (state)
            S000: begin
                next_state = x ? S001 : S000;
                z = 1'b0;
            end
            S001: begin
                next_state = x ? S100 : S001;
                z = 1'b0;
            end
            S010: begin
                next_state = x ? S001 : S010;
                z = 1'b0;
            end
            S011: begin
                next_state = x ? S010 : S001;
                z = 1'b1;
            end
            S100: begin
                next_state = x ? S100 : S011;
                z = 1'b1;
            end
            default: begin
                next_state = S000;
                z = 1'b0;
            end
        endcase
    end
endmodule
