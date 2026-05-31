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
    logic [1:0] pht [0:127];

    assign predict_history = ghr;
    // PHT table index calculation for prediction
    assign predict_taken = (pht[predict_pc ^ ghr] >= 2'd2);

    integer i;
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'd1;
        end else begin
            // Logic for GHR update
            if (train_valid && train_mispredicted)
                ghr <= {train_history[5:0], train_taken};
            else if (predict_valid)
                ghr <= {ghr[5:0], predict_taken};

            // Logic for PHT training
            if (train_valid) begin
                logic [6:0] idx = train_pc ^ train_history;
                if (train_taken) begin
                    if (pht[idx] < 2'd3) pht[idx] <= pht[idx] + 2'd1;
                end else begin
                    if (pht[idx] > 2'd0) pht[idx] <= pht[idx] - 2'd1;
                end
            end
        end
    end
endmodule