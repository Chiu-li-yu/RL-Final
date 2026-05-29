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
        end else begin
            if (count > 0) begin
                count <= count - 1'b1;
            end else begin
                count <= 10'd0;
            end
        end
    end

    assign tc = (count == 10'd0);

endmodule
