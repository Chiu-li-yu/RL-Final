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
    input [6:0] train_pc,
);

    logic [6:0] ghr;
    logic [1:0] pht [127:0];
    
    // Prediction logic
    logic [6:0] pred_index;
    assign pred_index = predict_pc ^ ghr;
    
    always @(*) begin
        predict_taken = pht[pred_index][1];
        predict_history = ghr;
    end
    
    // Training/Update logic
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'b01; // Weakly not taken
        end else begin
            // 1. Train first (takes precedence)
            if (train_valid) begin
                logic [6:0] train_index;
                train_index = train_history ^ train_pc;
                
                if (train_taken) begin
                    if (pht[train_index] < 2'b11) pht[train_index] <= pht[train_index] + 1'b1;
                end else begin
                    if (pht[train_index] > 2'b00) pht[train_index] <= pht[train_index] - 1'b1;
                end
                
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end else begin
                    // If prediction also happens, update GHR with prediction result
                    if (predict_valid) begin
                        ghr <= {ghr[5:0], pht[pred_index][1]};
                    end
                end
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], pht[pred_index][1]};
            end
        end
    end

endmodule