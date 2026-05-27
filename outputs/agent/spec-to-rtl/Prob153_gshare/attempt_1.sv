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

    logic [6:0] ghr;
    logic [1:0] pht [127:0];
    
    logic [6:0] predict_index;
    logic [6:0] train_index;
    logic [1:0] pht_out;

    assign predict_index = predict_pc ^ ghr;
    assign pht_out = pht[predict_index];
    assign predict_taken = (pht_out >= 2'b10);
    assign predict_history = ghr;

    assign train_index = train_pc ^ train_history;

    integer i;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i++) begin
                pht[i] <= 2'b01;
            end
        end else begin
            // Training logic takes precedence
            if (train_valid) begin
                // Update PHT
                if (train_taken) begin
                    if (pht[train_index] < 2'b11)
                        pht[train_index] <= pht[train_index] + 1;
                end else begin
                    if (pht[train_index] > 2'b00)
                        pht[train_index] <= pht[train_index] - 1;
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
