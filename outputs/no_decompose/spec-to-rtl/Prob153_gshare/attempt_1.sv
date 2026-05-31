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

    logic [6:0] ghr;
    logic [1:0] pht [0:127];
    logic [6:0] pht_idx_predict;
    logic [6:0] pht_idx_train;
    logic [6:0] next_ghr;
    
    assign pht_idx_predict = predict_pc ^ ghr;
    assign pht_idx_train = train_pc ^ train_history;

    assign predict_taken = (pht[pht_idx_predict] >= 2'b10);
    assign predict_history = ghr;

    integer i;
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'b01;
        end else begin
            if (train_valid) begin
                // Update PHT
                if (train_taken) begin
                    if (pht[pht_idx_train] < 2'b11) pht[pht_idx_train] <= pht[pht_idx_train] + 1;
                end else begin
                    if (pht[pht_idx_train] > 2'b00) pht[pht_idx_train] <= pht[pht_idx_train] - 1;
                end
                
                // Recover GHR if mispredicted
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end else if (predict_valid) begin
                    ghr <= {ghr[5:0], predict_taken};
                end
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule
