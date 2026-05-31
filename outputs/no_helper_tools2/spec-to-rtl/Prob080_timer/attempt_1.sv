module TopModule (
    input logic clk,
    input logic load,
    input logic [9:0] data,
    output logic tc
);
    logic [9:0] count;

    always_ff @(posedge clk) begin
        if (load) begin
            count <= data;
        end else if (count > 0) begin
            count <= count - 1'b1;
        end
    end

    always_comb begin
        tc = (count == 10'd0);
    end
endmodule