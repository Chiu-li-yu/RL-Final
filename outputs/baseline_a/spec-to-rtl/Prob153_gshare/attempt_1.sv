module TopModule (
    input logic clk,
    input logic areset,

    input logic predict_valid,
    input logic [6:0] predict_pc,
    output logic predict_taken,
    output logic [6:0] predict_history,

    input logic train_valid,
    input logic train_taken,
    input logic train_mispredicted,
    input logic [6:0] train_history,
    input logic [6:0] train_pc
);

    // 7-bit global history register
    logic [6:0] ghr;

    // 128-entry table of 2-bit saturating counters
    logic [1:0] pht [127:0];
    integer i;

    // Prediction logic
    logic [6:0] predict_index;
    assign predict_index = predict_pc ^ ghr;
    assign predict_history = ghr;
    assign predict_taken = (pht[predict_index] >= 2'd2);

    // Training logic
    logic [6:0] train_index;
    assign train_index = train_pc ^ train_history;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'd0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'd1; // Initialize to 01 (weakly not taken)
            end
        end else begin
            // History update logic
            // Training takes precedence over prediction update
            if (train_valid) begin
                if (train_mispredicted) begin
                    // Recover history: train_history is the history used,
                    // outcome is train_taken.
                    ghr <= {train_history[5:0], train_taken};
                end else begin
                    // Standard update: GHR already correct, shift in actual result
                    ghr <= {ghr[5:0], train_taken};
                end
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end

            // PHT update logic
            if (train_valid) begin
                if (train_taken) begin
                    if (pht[train_index] < 2'd3)
                        pht[train_index] <= pht[train_index] + 1'b1;
                end else begin
                    if (pht[train_index] > 2'd0)
                        pht[train_index] <= pht[train_index] - 1'b1;
                end
            end
        end
    end
endmodule
