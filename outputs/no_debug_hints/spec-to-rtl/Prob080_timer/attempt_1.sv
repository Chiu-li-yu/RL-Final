module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    logic [9:0] counter;
    logic tc_internal;

    assign tc = tc_internal;

    always_ff @(posedge clk) begin
        if (load) begin
            counter <= data;
        end else if (counter > 0) begin
            counter <= counter - 10'd1;
        end
    end

    always_comb begin
        if (counter == 10'd0) begin
            tc_internal = 1'b1;
        end else begin
            tc_internal = 1'b0;
        end
    end

endmodule
