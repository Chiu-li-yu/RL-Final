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
    logic [1:0] pht [127:0];

    // Predict calculation
    logic [6:0] predict_index;
    assign predict_index = predict_pc ^ ghr;
    
    always_comb begin
        predict_history = ghr;
        predict_taken = (predict_valid && (pht[predict_index] >= 2'd2));
    end

    // Sequential logic
    integer i;
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'd1; // Initialize to Weakly Not Taken (01)
        end else begin
            // 1. Training logic takes priority for GHR
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end

            // 2. Training logic for PHT
            if (train_valid) begin
                logic [6:0] train_index = train_pc ^ train_history;
                if (train_taken) begin
                    if (pht[train_index] < 2'd3) pht[train_index] <= pht[train_index] + 1'b1;
                end else begin
                    if (pht[train_index] > 2'd0) pht[train_index] <= pht[train_index] - 1'b1;
                end
            end
        end
    end
endmodule