module TopModule (
    input logic clk,
    input logic areset,
    input logic train_valid,
    input logic train_taken,
    output logic [1:0] state
);

    logic [1:0] next_state;

    always @(*) begin
        next_state = state;
        if (train_valid) begin
            if (train_taken) begin
                if (state < 2'b11)
                    next_state = state + 1;
                else
                    next_state = 2'b11;
            end else begin
                if (state > 2'b00)
                    next_state = state - 1;
                else
                    next_state = 2'b00;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;
        else
            state <= next_state;
    end

endmodule
