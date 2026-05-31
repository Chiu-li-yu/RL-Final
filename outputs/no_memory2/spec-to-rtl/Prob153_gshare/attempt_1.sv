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

    // Output logic (Combinational)
    always @(*) begin
        if (predict_valid) begin
            predict_history = ghr;
            predict_taken = pht[predict_pc ^ ghr][1];
        end else begin
            predict_history = 7'b0;
            predict_taken = 1'b0;
        end
    end

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01; // Initialize to 01 (weakly not taken)
        end else begin
            // Training logic
            if (train_valid) begin
                logic [6:0] train_index = train_pc ^ train_history;
                
                // Update PHT
                if (train_taken) begin
                    if (pht[train_index] < 2'b11) pht[train_index] <= pht[train_index] + 1;
                end else begin
                    if (pht[train_index] > 2'b00) pht[train_index] <= pht[train_index] - 1;
                end
                
                // Update GHR if mispredicted
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end else if (predict_valid) begin
                    // If not mispredicted but predict_valid, update GHR with prediction
                    ghr <= {ghr[5:0], pht[predict_pc ^ ghr][1]};
                end
            end else if (predict_valid) begin
                // Update GHR with prediction
                ghr <= {ghr[5:0], pht[predict_pc ^ ghr][1]};
            end
        end
    end

endmodule