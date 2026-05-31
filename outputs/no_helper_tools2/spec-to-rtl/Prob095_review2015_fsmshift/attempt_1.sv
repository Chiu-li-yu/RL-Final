module TopModule (
    input clk,
    input reset,
    output shift_ena
);
    logic [2:0] count;
    logic ena;

    assign shift_ena = ena;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd1;
            ena <= 1'b1;
        end else if (ena) begin
            if (count == 3'd4) begin
                ena <= 1'b0;
                count <= 3'd0;
            end else begin
                count <= count + 3'd1;
            end
        end
    end
endmodule
