module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    logic [1:0] counter_q;
    logic [1:0] counter_d;

    assign state = counter_q;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter_q <= 2'b01;
        end else begin
            counter_q <= counter_d;
        end
    end

    always @(*) begin
        counter_d = counter_q;
        if (train_valid) begin
            if (train_taken) begin
                if (counter_q < 2'd3) begin
                    counter_d = counter_q + 2'd1;
                end
            end else begin
                if (counter_q > 2'd0) begin
                    counter_d = counter_q - 2'd1;
                end
            end
        end
    end

endmodule
