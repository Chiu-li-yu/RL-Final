module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output logic Y0,
    output logic z
);

    always @(*) begin
        // Default values to avoid latches
        Y0 = 1'b0;
        z = 1'b0;
        
        case (y)
            3'b000: begin
                z = 1'b0;
                if (x == 1'b0) 
                    Y0 = 1'b0; // Next Y = 000
                else 
                    Y0 = 1'b1; // Next Y = 001
            end
            3'b001: begin
                z = 1'b0;
                if (x == 1'b0) 
                    Y0 = 1'b1; // Next Y = 001
                else 
                    Y0 = 1'b0; // Next Y = 100
            end
            3'b010: begin
                z = 1'b0;
                if (x == 1'b0) 
                    Y0 = 1'b0; // Next Y = 010
                else 
                    Y0 = 1'b1; // Next Y = 001
            end
            3'b011: begin
                z = 1'b1;
                if (x == 1'b0) 
                    Y0 = 1'b1; // Next Y = 001
                else 
                    Y0 = 1'b0; // Next Y = 010
            end
            3'b100: begin
                z = 1'b1;
                if (x == 1'b0) 
                    Y0 = 1'b1; // Next Y = 011
                else 
                    Y0 = 1'b0; // Next Y = 100
            end
            default: begin
                z = 1'b0;
                Y0 = 1'b0;
            end
        endcase
    end

endmodule
