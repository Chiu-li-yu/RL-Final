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

    // Default: predict_history is current GHR, predict_taken is from PHT[pc ^ ghr]
    assign predict_history = ghr;
    assign predict_taken = (pht[predict_pc ^ ghr] >= 2'b10);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'b01; 
        end else begin
            // Training logic: training takes precedence
            if (train_valid) begin
                // Update PHT based on train_taken
                if (train_taken) begin
                    if (pht[train_pc ^ train_history] < 2'b11)
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1'b1;
                end else begin
                    if (pht[train_pc ^ train_history] > 2'b00)
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1'b1;
                end
                
                // If mispredicted, GHR correction
                if (train_mispredicted)
                    ghr <= {train_history[5:0], train_taken};
            end
            
            // Prediction update logic: only if no training or training doesn't mispredict?
            // "If training for a misprediction and a prediction ... occurs in the same cycle ... 
            // training takes precedence"
            // So if NOT training, we update GHR based on current prediction.
            else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end
endmodule