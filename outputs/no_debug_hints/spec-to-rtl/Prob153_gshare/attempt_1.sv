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

    // Output logic
    assign predict_history = ghr;
    assign predict_taken = (pht[predict_pc ^ ghr] >= 2'b10);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01; // Initialize to Weakly Not Taken
            end
        end else begin
            // Training logic
            if (train_valid) begin
                logic [6:0] train_idx = train_pc ^ train_history;
                if (train_taken) begin
                    if (pht[train_idx] < 2'b11) pht[train_idx] <= pht[train_idx] + 1'b1;
                end else begin
                    if (pht[train_idx] > 2'b00) pht[train_idx] <= pht[train_idx] - 1'b1;
                end

                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end else if (predict_valid) begin
                    // Training and prediction happen, but training takes precedence
                    // The GHR should follow the trained path if mispredicted,
                    // otherwise follow the predicted path.
                    // Based on "When training and prediction ... training takes precedence"
                    ghr <= {ghr[5:0], predict_taken};
                end
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end
endmodule
