module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    logic [9:0] count;

    always_ff @(posedge clk) begin
        if (load) begin
            count <= data;
        end else if (count > 0) begin
            count <= count - 10'd1;
        end
    end

    assign tc = (count == 10'd0);

endmodule
