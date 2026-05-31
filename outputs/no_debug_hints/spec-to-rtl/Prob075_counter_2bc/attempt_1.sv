module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output logic [1:0] state
);
    logic [1:0] next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        if (train_valid) begin
            if (train_taken) begin
                if (state < 2'b11)
                    next_state = state + 1'b1;
            end else begin
                if (state > 2'b00)
                    next_state = state - 1'b1;
            end
        end
    end
endmodule
