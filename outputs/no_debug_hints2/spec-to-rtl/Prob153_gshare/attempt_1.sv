module TopModule(
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
    input [6:0] train_pc,
    output reg [6:0] predict_history_out
);
    logic [1:0] pht [127:0];
    logic [6:0] ghr;
    logic [6:0] predict_index;
    logic [6:0] train_index;

    assign predict_index = predict_pc ^ ghr;
    assign train_index = train_pc ^ train_history;

    assign predict_taken = (pht[predict_index] >= 2);
    assign predict_history = ghr;

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01; // Initialize to Weakly Not Taken
        end else begin
            // Training priority for GHR
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end

            // PHT Update
            if (train_valid) begin
                if (train_taken) begin
                    if (pht[train_index] != 2'b11)
                        pht[train_index] <= pht[train_index] + 1;
                end else begin
                    if (pht[train_index] != 2'b00)
                        pht[train_index] <= pht[train_index] - 1;
                end
            end
        end
    end
endmodule