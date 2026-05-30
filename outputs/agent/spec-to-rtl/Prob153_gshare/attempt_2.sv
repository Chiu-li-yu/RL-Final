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

    // Output logic
    assign predict_history = ghr;
    assign predict_taken = (pht[predict_pc ^ ghr] >= 2'b10);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'b01; 
        end else begin
            // Training logic - highest precedence
            if (train_valid) begin
                // Update PHT
                if (train_taken) begin
                    if (pht[train_pc ^ train_history] < 2'b11)
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1'b1;
                end else begin
                    if (pht[train_pc ^ train_history] > 2'b00)
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1'b1;
                end
                
                // If mispredicted, restore GHR to correct state
                if (train_mispredicted)
                    ghr <= {train_history[5:0], train_taken};
            end
            // Prediction logic - if no training, or if training doesn't involve current GHR update
            // Wait: Specification says "training takes precedence" for GHR update if both occur.
            // If predict_valid and NOT (train_valid and train_mispredicted), update GHR normally?
            // "If training for a misprediction and a prediction (for a different, younger instruction) 
            // occurs in the same cycle ... training takes precedence"
            else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end
endmodule