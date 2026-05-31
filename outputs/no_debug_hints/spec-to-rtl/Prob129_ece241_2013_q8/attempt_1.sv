module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);
    // Mealy FSM to detect "101"
    // State 0: Initial / Waiting for '1'
    // State 1: '1' detected
    // State 2: '10' detected
    
    logic [1:0] state, next_state;
    logic z_out;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= 2'b00;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        z_out = 1'b0;
        case (state)
            2'b00: begin
                if (x) next_state = 2'b01;
                else   next_state = 2'b00;
            end
            2'b01: begin
                if (!x) next_state = 2'b10;
                else    next_state = 2'b01;
            end
            2'b10: begin
                if (x) begin
                    next_state = 2'b01;
                    z_out = 1'b1; // Detected 101
                end else begin
                    next_state = 2'b00;
                end
            end
            default: next_state = 2'b00;
        endcase
    end

    assign z = z_out;
endmodule
