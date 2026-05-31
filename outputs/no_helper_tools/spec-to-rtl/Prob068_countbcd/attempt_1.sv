module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    logic [15:0] count;
    
    // Enable signals for each digit
    // ena[0]: increment tens (q[7:4])
    // ena[1]: increment hundreds (q[11:8])
    // ena[2]: increment thousands (q[15:12])
    
    assign ena[0] = (count[3:0] == 4'd9);
    assign ena[1] = (count[3:0] == 4'd9) && (count[7:4] == 4'd9);
    assign ena[2] = (count[3:0] == 4'd9) && (count[7:4] == 4'd9) && (count[11:8] == 4'd9);
    
    assign q = count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
        end else begin
            // Ones digit
            if (count[3:0] == 4'd9)
                count[3:0] <= 4'd0;
            else
                count[3:0] <= count[3:0] + 1'b1;
            
            // Tens digit
            if (ena[0]) begin
                if (count[7:4] == 4'd9)
                    count[7:4] <= 4'd0;
                else
                    count[7:4] <= count[7:4] + 1'b1;
            end
            
            // Hundreds digit
            if (ena[1]) begin
                if (count[11:8] == 4'd9)
                    count[11:8] <= 4'd0;
                else
                    count[11:8] <= count[11:8] + 1'b1;
            end
            
            // Thousands digit
            if (ena[2]) begin
                if (count[15:12] == 4'd9)
                    count[15:12] <= 4'd0;
                else
                    count[15:12] <= count[15:12] + 1'b1;
            end
        end
    end

endmodule
