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
                // Misprediction takes precedence
                // Load history: (train_history << 1) | train_taken
                // Or simply: {train_history[30:0], train_taken}
                // The prompt says: "history before the mispredicted branch (train_history) concatenated with the actual result"
                // Usually global history: [N-1:0]. Shift in: {history[N-2:0], new_bit}
                history_reg <= {train_history[30:0], train_taken};
            end else if (predict_valid) begin
                // Shift in predict_taken from LSB side
                history_reg <= {history_reg[30:0], predict_taken};
            end
        end
    end

endmodule
