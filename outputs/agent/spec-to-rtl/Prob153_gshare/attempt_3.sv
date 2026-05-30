module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input [6:0] predict_pc,
    output logic predict_taken,
    output logic [6:0] predict_history,
    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    logic [6:0] ghr;
    logic [1:0] pht [0:127];
    integer i;

    // The prediction must see PHT state before current cycle's training updates
    // The outputs are combinatorial.
    assign predict_history = ghr;
    assign predict_taken = (pht[predict_pc ^ ghr] >= 2'b10);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'b01; 
        end else begin
            // 1. Train Logic
            if (train_valid) begin
                // Update PHT
                if (train_taken) begin
                    if (pht[train_pc ^ train_history] != 2'b11)
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1'b1;
                end else begin
                    if (pht[train_pc ^ train_history] != 2'b00)
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1'b1;
                end
                
                // If mispredicted, override GHR
                if (train_mispredicted)
                    ghr <= {train_history[5:0], train_taken};
                // If not mispredicted, only train PHT (GHR remains same)
            end
            // 2. Predict Logic (only if not training or if training didn't update GHR)
            // Actually the spec says "When a branch prediction is requested ... GHR is updated (at next edge)"
            // "If both occur, training takes precedence"
            // So if train_valid is true, we ONLY update GHR based on training.
            // If train_valid is false and predict_valid is true, update GHR.
            else if (predict_valid) begin
                ghr <= {ghr[5:0], (pht[predict_pc ^ ghr] >= 2'b10)};
            end
        end
    end
endmodule