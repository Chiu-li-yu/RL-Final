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

    // Output for prediction
    assign predict_history = ghr;
    assign predict_taken = (pht[predict_pc ^ ghr] >= 2'b10);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'b01; // Initial state
        end else begin
            // 1. Calculate next GHR
            // Priority: Train > Predict
            logic next_ghr_valid;
            logic [6:0] next_ghr_val;
            
            if (train_valid && train_mispredicted) begin
                next_ghr_val = {train_history[5:0], train_taken};
                next_ghr_valid = 1'b1;
            end else if (predict_valid) begin
                next_ghr_val = {ghr[5:0], predict_taken};
                next_ghr_valid = 1'b1;
            end else begin
                next_ghr_val = ghr;
                next_ghr_valid = 1'b0;
            end
            
            // 2. Update PHT
            if (train_valid) begin
                logic [6:0] idx = train_pc ^ train_history;
                if (train_taken) begin
                    if (pht[idx] < 2'b11) pht[idx] <= pht[idx] + 1'b1;
                end else begin
                    if (pht[idx] > 2'b00) pht[idx] <= pht[idx] - 1'b1;
                end
            end
            
            // 3. Update GHR
            if (next_ghr_valid) ghr <= next_ghr_val;
        end
    end
endmodule
