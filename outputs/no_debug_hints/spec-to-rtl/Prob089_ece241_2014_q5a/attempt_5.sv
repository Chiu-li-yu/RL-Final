module TopModule (
    input logic clk,
    input logic areset,
    input logic x,
    output logic z
);

    // Re-evaluating 2's complement serial:
    // It is normally Mealy. If I must implement as Moore, I must register the output.
    // The output for Mealy is: 
    // z = x if no 1 seen
    // z = !x if 1 seen
    
    // To make it Moore, output z must be registered.
    // Let's use a Mealy implementation and register the output.
    
    logic state;
    logic next_state;
    logic z_mealy;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= z_mealy;
        end
    end

    always_comb begin
        if (state == 1'b0) begin
            next_state = (x == 1'b1) ? 1'b1 : 1'b0;
            z_mealy = x;
        end else begin
            next_state = 1'b1;
            z_mealy = ~x;
        end
    end

endmodule
