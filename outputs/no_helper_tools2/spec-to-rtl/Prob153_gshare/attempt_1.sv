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

    logic [1:0] pht [0:127];
    logic [6:0] ghr;
    integer i;

    // Output current GHR for prediction
    assign predict_history = ghr;

    // Prediction logic
    always @(*) begin
        logic [6:0] index;
        index = predict_pc ^ ghr;
        predict_taken = pht[index][1];
    end

    // Sequential update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'b01; // Weakly not taken
        end else begin
            // Training logic takes precedence
            if (train_valid) begin
                logic [6:0] train_index;
                train_index = train_pc ^ train_history;
                
                // Update PHT
                if (train_taken) begin
                    if (pht[train_index] < 2'b11) pht[train_index] <= pht[train_index] + 1;
                end else begin
                    if (pht[train_index] > 2'b00) pht[train_index] <= pht[train_index] - 1;
                end

                // GHR recovery
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end else begin
                    // If not mispredicted, GHR remains as is (or normal shift)
                    // The prompt implies GHR update for prediction happens, 
                    // but training precedence overrides prediction update.
                end
            end else if (predict_valid) begin
                // Update GHR for prediction
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule
