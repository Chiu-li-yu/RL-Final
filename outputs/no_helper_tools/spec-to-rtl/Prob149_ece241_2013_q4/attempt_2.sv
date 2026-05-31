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

    always @(*) begin
        case (s)
            3'b111: current_level = 2'd3;
            3'b011: current_level = 2'd2;
            3'b001: current_level = 2'd1;
            default: current_level = 2'd0;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset)
            prev_level <= 2'd0;
        else
            prev_level <= current_level;
    end

    always @(*) begin
        if (reset) begin
            fr2 = 1; fr1 = 1; fr0 = 1; dfr = 1;
        end else begin
            case (current_level)
                2'd3: begin fr2 = 0; fr1 = 0; fr0 = 0; dfr = 0; end
                2'd2: begin 
                    fr2 = 0; fr1 = 0; fr0 = 1; 
                    dfr = (prev_level > current_level) ? 1 : 0; 
                end
                2'd1: begin 
                    fr2 = 0; fr1 = 1; fr0 = 1; 
                    dfr = (prev_level > current_level) ? 1 : 0; 
                end
                2'd0: begin fr2 = 1; fr1 = 1; fr0 = 1; dfr = 0; end
                default: begin fr2 = 1; fr1 = 1; fr0 = 1; dfr = 1; end
            endcase
        end
    end

endmodule
