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
    input [6:0] train_pc,
    output logic predict_taken_out,
    output logic [6:0] predict_history_out
);
    // PHT: 128 entries of 2-bit counters
    logic [1:0] pht [127:0];
    logic [6:0] ghr;

    // Assignment for output ports
    assign predict_history = ghr;

    // Prediction logic
    logic [6:0] predict_index;
    assign predict_index = predict_pc ^ ghr;
    
    // Use assign for combinational logic of prediction
    always @(*) begin
        predict_taken = (pht[predict_index] >= 2'b10);
    end

    // Sequential logic for GHR and PHT
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (int i = 0; i < 128; i++) pht[i] <= 2'b01; // Initialize to weakly not taken
        end else begin
            // Training takes priority for GHR if mispredicted
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
            
            // PHT Update
            if (train_valid) begin
                logic [6:0] train_index = train_pc ^ train_history;
                if (train_taken) begin
                    if (pht[train_index] < 2'b11) pht[train_index] <= pht[train_index] + 1;
                end else begin
                    if (pht[train_index] > 2'b00) pht[train_index] <= pht[train_index] - 1;
                end
            end
        end
    end

endmodule
