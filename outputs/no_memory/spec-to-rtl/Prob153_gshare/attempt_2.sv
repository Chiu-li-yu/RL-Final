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
    logic [1:0] pht [127:0];
    integer i;

    // Combinational logic for prediction
    logic [6:0] predict_index;
    assign predict_index = predict_pc ^ ghr;
    assign predict_taken = (predict_valid && pht[predict_index] >= 2);
    assign predict_history = ghr;

    // Synchronous update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'b01;
        end else begin
            // 1. Training (takes precedence)
            if (train_valid) begin
                logic [6:0] train_index;
                train_index = train_pc ^ train_history;
                
                if (train_taken) begin
                    if (pht[train_index] < 2'b11) pht[train_index] <= pht[train_index] + 1'b1;
                end else begin
                    if (pht[train_index] > 2'b00) pht[train_index] <= pht[train_index] - 1'b1;
                end
                
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end else if (predict_valid) begin
                    ghr <= {ghr[5:0], predict_taken};
                end
            end else if (predict_valid) begin
                // 2. Prediction update
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule
