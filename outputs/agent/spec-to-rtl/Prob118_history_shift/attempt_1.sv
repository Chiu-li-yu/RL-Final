module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    logic [31:0] history_reg;

    assign predict_history = history_reg;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else begin
            if (train_mispredicted) begin
                // Load history after mispredicted branch: train_history concatenated with train_taken
                history_reg <= {train_history[30:0], train_taken};
            end else if (predict_valid) begin
                // Shift in predict_taken from the LSB side
                history_reg <= {history_reg[30:0], predict_taken};
            end
        end
    end

endmodule
