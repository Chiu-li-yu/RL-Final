module TopModule(
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

    // Predict calculation
    assign predict_history = ghr;
    assign predict_taken = (pht[predict_pc ^ ghr] >= 2'd2);

    integer i;
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'd1;
        end else begin
            // Training priority over prediction
            if (train_valid) begin
                logic [6:0] train_idx = train_pc ^ train_history;
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end else if (predict_valid) begin
                    ghr <= {ghr[5:0], predict_taken};
                end
                
                // Update PHT
                if (train_taken) begin
                    if (pht[train_idx] < 2'd3) pht[train_idx] <= pht[train_idx] + 2'd1;
                end else begin
                    if (pht[train_idx] > 2'd0) pht[train_idx] <= pht[train_idx] - 2'd1;
                end
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end
endmodule