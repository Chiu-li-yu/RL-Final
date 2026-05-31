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
    logic [1:0] pht [127:0];
    integer i;

    // Output current state for prediction
    always @(*) begin
        predict_history = ghr;
        predict_taken = pht[predict_pc ^ ghr][1];
    end

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'b01; // Initialize to Weakly Not Taken
        end else begin
            if (train_valid) begin
                // Training takes precedence
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
                end else if (predict_valid) begin
                    // Prediction update
                    ghr <= {ghr[5:0], predict_taken};
                end
            end else if (predict_valid) begin
                // Just prediction update
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule