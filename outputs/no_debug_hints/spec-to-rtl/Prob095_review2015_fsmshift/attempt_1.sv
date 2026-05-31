module TopModule (
    input clk,
    input reset,
    output logic shift_ena
);
    logic [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;
            shift_ena <= 1'b1;
        end else begin
            if (counter > 3'd1) begin
                counter <= counter - 3'd1;
                shift_ena <= 1'b1;
            end else begin
                counter <= 3'd0;
                shift_ena <= 1'b0;
            end
        end
    end
endmodule
