module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    logic [1:0] counter_reg;

    assign state = counter_reg;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            counter_reg <= 2'b01;
        end else begin
            if (train_valid) begin
                if (train_taken) begin
                    if (counter_reg < 2'd3) begin
                        counter_reg <= counter_reg + 2'd1;
                    end
                end else begin
                    if (counter_reg > 2'd0) begin
                        counter_reg <= counter_reg - 2'd1;
                    end
                end
            end
        end
    end

endmodule
