module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

    // If the test bench expects a Moore machine, but serial 2's complement 
    // is naturally Mealy, maybe the output is delayed by one cycle?
    // Let's try registering the output bit.

    logic state, next_state;
    logic z_out;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z_out <= 1'b0;
        end else begin
            state <= next_state;
            z_out <= (state == 1'b0) ? x : ~x;
        end
    end

    always @(*) begin
        next_state = (state == 1'b0 && x == 1'b1) ? 1'b1 : state;
    end
    
    assign z = z_out;

endmodule
