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
    
    // Prediction logic
    logic [6:0] predict_idx;
    assign predict_idx = predict_pc ^ ghr;
    assign predict_taken = (pht[predict_idx] >= 2'b10);
    assign predict_history = ghr;

    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'b01;
        end else begin
            // 1. Update PHT if train_valid
            if (train_valid) begin
                logic [6:0] train_idx = train_pc ^ train_history;
                if (train_taken) begin
                    if (pht[train_idx] != 2'b11) pht[train_idx] <= pht[train_idx] + 2'b01;
                end else begin
                    if (pht[train_idx] != 2'b00) pht[train_idx] <= pht[train_idx] - 2'b01;
                end
            end

            // 2. Update GHR
            // Training takes precedence over prediction
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end
endmodule
