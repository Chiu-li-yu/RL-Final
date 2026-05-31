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

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else begin
            if (train_mispredicted) begin
                // Load history: train_history concatenated with train_taken
                // Specification: "history before the mispredicted branch (train_history) 
                // concatenated with the actual result of the branch (train_taken)"
                // Note: predict_history[0] is the youngest branch.
                // If history is [N-1:0], history[0] is youngest.
                // If the history before branch was train_history (where train_history[0] was the youngest),
                // the new history becomes {train_history[30:0], train_taken}.
                history_reg <= {train_history[30:0], train_taken};
            end else if (predict_valid) begin
                // Shift in predict_taken from the LSB side
                // predict_history[0] is youngest. 
                // {history_reg[30:0], predict_taken}
                history_reg <= {history_reg[30:0], predict_taken};
            end
        end
    end

    assign predict_history = history_reg;

endmodule
