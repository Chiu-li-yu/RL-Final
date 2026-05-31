module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    logic [1:0] current_level;
    logic [1:0] prev_level;

    // Decode current level
    always @(*) begin
        if (s == 3'b111) current_level = 2'd3;
        else if (s == 3'b011) current_level = 2'd2;
        else if (s == 3'b001) current_level = 2'd1;
        else current_level = 2'd0;
    end

    // Sequential update
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;
        end else if (current_level != prev_level) begin
            prev_level <= current_level;
        end
    end

    // Output logic
    always @(*) begin
        if (reset) begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end else begin
            case (current_level)
                2'd3: begin
                    fr2 = 1'b0; fr1 = 1'b0; fr0 = 1'b0;
                end
                2'd2: begin
                    fr2 = 1'b0; fr1 = 1'b0; fr0 = 1'b1;
                end
                2'd1: begin
                    fr2 = 1'b0; fr1 = 1'b1; fr0 = 1'b1;
                end
                2'd0: begin
                    fr2 = 1'b1; fr1 = 1'b1; fr0 = 1'b1;
                end
                default: begin
                    fr2 = 1'b0; fr1 = 1'b0; fr0 = 1'b0;
                end
            endcase
            
            // dfr: if level is falling (prev_level > current_level)
            if (prev_level > current_level)
                dfr = 1'b1;
            else
                dfr = 1'b0;
        end
    end

endmodule
