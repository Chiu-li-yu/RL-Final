module TopModule (
    input logic clk,
    input logic areset,
    input logic predict_valid,
    input logic [6:0] predict_pc,
    output logic predict_taken,
    output logic [6:0] predict_history,
    input logic train_valid,
    input logic train_taken,
    input logic train_mispredicted,
    input logic [6:0] train_history,
    input logic [6:0] train_pc
);

    logic [6:0] ghr;
    logic [1:0] pht [127:0];
    logic [6:0] next_ghr;
    logic [6:0] train_index;
    logic [6:0] predict_index;
    logic [1:0] next_pht_entry;

    assign predict_index = predict_pc ^ ghr;
    assign predict_taken = (pht[predict_index] >= 2'd2);
    assign predict_history = ghr;

    assign train_index = train_pc ^ train_history;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'd0;
            for (int i = 0; i < 128; i++) pht[i] <= 2'd1;
        end else begin
            // Update GHR
            if (train_valid) begin
                if (train_mispredicted)
                    ghr <= {train_history[5:0], train_taken};
                else
                    ghr <= {ghr[5:0], predict_valid ? predict_taken : 1'b0}; // Wait, this logic is tricky based on description
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end

            // Update PHT
            if (train_valid) begin
                if (train_taken) begin
                    if (pht[train_index] < 2'd3) pht[train_index] <= pht[train_index] + 1'b1;
                end else begin
                    if (pht[train_index] > 2'd0) pht[train_index] <= pht[train_index] - 1'b1;
                end
            end
        end
    end

endmodule
