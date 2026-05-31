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
    logic [1:0] pht [0:127];

    assign predict_history = ghr;
    assign predict_taken = (pht[predict_pc ^ ghr] >= 2'b10);

    integer i;
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'b01;
        end else begin
            // Based on specs: "If training for a misprediction and a prediction (for a different, younger instruction) 
            // occurs in the same cycle... training takes precedence"
            // AND "if the branch being trained is mispredicted, also recover the branch history register"
            
            if (train_valid) begin
                // PHT update
                if (train_taken) begin
                    if (pht[train_pc ^ train_history] != 2'b11)
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1'b1;
                end else begin
                    if (pht[train_pc ^ train_history] != 2'b00)
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1'b1;
                end
                
                // GHR update
                if (train_mispredicted)
                    ghr <= {train_history[5:0], train_taken};
                else
                    ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end
endmodule