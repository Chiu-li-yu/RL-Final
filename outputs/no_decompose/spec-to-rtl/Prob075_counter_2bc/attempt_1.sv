module TopModule (
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

    logic [1:0] counter;

    assign state = counter;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;
        end else begin
            if (train_valid) begin
                if (train_taken) begin
                    if (counter < 2'b11)
                        counter <= counter + 1'b1;
                end else begin
                    if (counter > 2'b00)
                        counter <= counter - 1'b1;
                end
            end
        end
    end

endmodule
