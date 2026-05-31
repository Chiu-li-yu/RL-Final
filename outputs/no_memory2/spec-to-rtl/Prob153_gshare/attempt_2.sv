module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,
    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    logic [1:0] pht [0:127];
    logic [6:0] ghr;
    
    // Initializing PHT and GHR logic
    integer i;
    
    // Prediction logic
    logic [6:0] predict_index;
    assign predict_index = predict_pc ^ ghr;
    assign predict_taken = (predict_valid) ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'b01;
        end else begin
            // Training takes precedence for GHR updates
            if (train_valid) begin
                // Update PHT
                if (train_taken) begin
                    if (pht[train_pc ^ train_history] < 2'b11)
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1;
                end else begin
                    if (pht[train_pc ^ train_history] > 2'b00)
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1;
                end
                
                // If mispredicted, recover GHR
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end else begin
                    // If prediction also happened, train update prevails.
                    // Spec says: "If training for a misprediction and a prediction... occurs in the same cycle... 
                    // training takes precedence."
                    // If no mispredict, GHR doesn't change due to training.
                    if (predict_valid)
                        ghr <= {ghr[5:0], pht[predict_index][1]};
                end
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], pht[predict_index][1]};
            end
        end
    end

endmodule
