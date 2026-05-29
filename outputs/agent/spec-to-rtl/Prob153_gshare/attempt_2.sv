
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

    logic [6:0] predict_index;
    logic [6:0] train_index;

    assign predict_index = predict_pc ^ ghr;
    assign train_index = train_pc ^ train_history;

    assign predict_taken = pht[predict_index] >= 2'd2;
    assign predict_history = ghr;

    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'd0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'd1; // Try initializing to Weakly Not Taken
            end
        end else begin
            // GHR update
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end

            // PHT update
            if (train_valid) begin
                if (train_taken) begin
                    if (pht[train_index] < 2'd3)
                        pht[train_index] <= pht[train_index] + 2'd1;
                end else begin
                    if (pht[train_index] > 2'd0)
                        pht[train_index] <= pht[train_index] - 2'd1;
                end
            end
        end
    end

endmodule
