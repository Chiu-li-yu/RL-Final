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
    logic [1:0] pht [0:127];
    integer i;

    // Based on the spec: predict_history is the state used to make the prediction
    // which is GHR.
    assign predict_history = ghr;
    // predict_taken uses the current PHT state.
    assign predict_taken = (pht[predict_pc ^ ghr] >= 2'b10);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) pht[i] <= 2'b01; 
        end else begin
            // "If both occur, training takes precedence"
            // "The PHT is updated at the next cycle"
            // Let's perform both if needed, with training taking precedence for GHR.
            
            // GHR Update Logic:
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
            
            // PHT Update Logic:
            if (train_valid) begin
                if (train_taken) begin
                    if (pht[train_pc ^ train_history] != 2'b11)
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1'b1;
                end else begin
                    if (pht[train_pc ^ train_history] != 2'b00)
                        pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1'b1;
                end
            end
        end
    end
endmodule