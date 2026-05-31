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
    
    assign predict_history = ghr;
    assign predict_taken = (pht[predict_pc ^ ghr] >= 2'd2);

    integer i;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'd0;
            for (i = 0; i < 128; i++) pht[i] <= 2'd1;
        end else begin
            if (train_valid) begin
                // Update PHT
                if (train_taken) begin
                    if (pht[train_pc ^ train_history] < 2'd3) 
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1'b1;
                end else begin
                    if (pht[train_pc ^ train_history] > 2'd0) 
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1'b1;
                end
                
                // Update GHR: if mispredicted, recover
                if (train_mispredicted)
                    ghr <= {train_history[5:0], train_taken};
                else if (predict_valid)
                    ghr <= {ghr[5:0], predict_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule
