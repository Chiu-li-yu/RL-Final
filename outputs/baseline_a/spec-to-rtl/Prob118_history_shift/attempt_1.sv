module TopModule (
    input logic clk,
    input logic areset,
    input logic predict_valid,
    input logic predict_taken,
    input logic train_mispredicted,
    input logic train_taken,
    input logic [31:0] train_history,
    output logic [31:0] predict_history
);

    logic [31:0] history_reg;

    assign predict_history = history_reg;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else begin
            if (train_mispredicted) begin
                // Misprediction takes precedence:
                // Load history: train_history (the state before the mispredicted branch) 
                // concatenated with train_taken (the actual outcome of that branch).
                // Assuming LSB is the youngest:
                // History shifted: new_bit | (old_history << 1)
                // Wait, specification: "history after the completion of the mispredicted branch"
                // "this is the history before the mispredicted branch (train_history) 
                // concatenated with the actual result of the branch (train_taken)"
                // Based on "predict_history[0] is the direction of the youngest branch":
                // If we shift predict_taken from LSB, it means:
                // history[31:0] = {predict_taken, history[31:1]}
                // Therefore, train_history shifted with train_taken would be:
                // {train_taken, train_history[31:1]}
                history_reg <= {train_taken, train_history[31:1]};
            end else if (predict_valid) begin
                // predict_taken shifted in from LSB:
                history_reg <= {predict_taken, history_reg[31:1]};
            end
        end
    end

endmodule
