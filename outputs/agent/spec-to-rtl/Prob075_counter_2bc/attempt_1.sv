module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output logic [1:0] state
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;
        end else begin
            if (train_valid) begin
                if (train_taken) begin
                    if (state != 2'b11) begin
                        state <= state + 2'b01;
                    end
                end else begin
                    if (state != 2'b00) begin
                        state <= state - 2'b01;
                    end
                end
            end
            // When train_valid == 0, state keeps its value.
        end
    end

endmodule
