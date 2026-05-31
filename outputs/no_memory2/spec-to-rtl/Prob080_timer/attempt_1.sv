module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);
    logic [9:0] count;

    always @(posedge clk) begin
        if (load) begin
            count <= data;
        end else if (count > 0) begin
            count <= count - 1'b1;
        end else begin
            count <= 10'd0;
        end
    end

    always @(*) begin
        if (count == 10'd0) begin
            // 題目要求：一旦計數器到達 0，它就應該保持為 0。
            // 且當 count 為 0 時 tc 應該為高電位。
            // 根據規格 "Once the internal counter has reached 0, 
            // it should stay 0 (stop counting) until the counter is loaded again."
            // 並且 tc "indicates whether the internal counter has reached 0."
            tc = 1'b1;
        end else begin
            tc = 1'b0;
        end
    end
endmodule
