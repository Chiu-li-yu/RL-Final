module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    logic [2:0] state;
    logic [2:0] next_state;
    logic z_out;

    // Output Y0 is defined as Y[0] of the next state
    assign Y0 = next_state[0];
    assign z = z_out;

    // FSM State Transition Logic
    always @(*) begin
        case (state)
            3'b000: begin
                next_state = (x) ? 3'b001 : 3'b000;
                z_out = 0;
            end
            3'b001: begin
                next_state = (x) ? 3'b100 : 3'b001;
                z_out = 0;
            end
            3'b010: begin
                next_state = (x) ? 3'b001 : 3'b010;
                z_out = 0;
            end
            3'b011: begin
                next_state = (x) ? 3'b010 : 3'b001;
                z_out = 1;
            end
            3'b100: begin
                next_state = (x) ? 3'b100 : 3'b011;
                z_out = 1;
            end
            default: begin
                next_state = 3'b000;
                z_out = 0;
            end
        endcase
    end

    // Sequential update
    always @(posedge clk) begin
        state <= next_state;
    end

endmodule