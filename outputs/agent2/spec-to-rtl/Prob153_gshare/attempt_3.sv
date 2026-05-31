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

    assign predict_history = ghr;
    assign predict_taken = (pht[predict_pc ^ ghr] >= 2'b10);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (int i = 0; i < 128; i++) pht[i] <= 2'b01;
        end else begin
            // Update GHR
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end

            // Update PHT
            if (train_valid) begin
                logic [6:0] idx = train_pc ^ train_history;
                if (train_taken) begin
                    if (pht[idx] != 2'b11) pht[idx] <= pht[idx] + 2'b01;
                end else begin
                    if (pht[idx] != 2'b00) pht[idx] <= pht[idx] - 2'b01;
                end
            end
        end
    end
endmodule
