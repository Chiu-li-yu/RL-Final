module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // Level encoding based on sensors:
    // Level 3 (Above s[2]): s=3'b111
    // Level 2 (s[2] to s[1]): s=3'b011
    // Level 1 (s[1] to s[0]): s=3'b001
    // Level 0 (Below s[0]): s=3'b000
    // We only care about valid combinations, assume s is always valid 000, 001, 011, 111.

    logic [1:0] current_level;
    logic [1:0] prev_level;

    always @(*) begin
        if (s == 3'b111) current_level = 2'd3;
        else if (s == 3'b011) current_level = 2'd2;
        else if (s == 3'b001) current_level = 2'd1;
        else current_level = 2'd0;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;
        end else begin
            prev_level <= current_level;
        end
    end

    always @(*) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} = 4'b1111;
        end else begin
            case (current_level)
                2'd3: {fr2, fr1, fr0, dfr} = 4'b0000;
                2'd2: {fr2, fr1, fr0, dfr} = (prev_level > current_level) ? 4'b0011 : 4'b0010;
                2'd1: {fr2, fr1, fr0, dfr} = (prev_level > current_level) ? 4'b0111 : 4'b0110;
                2'd0: {fr2, fr1, fr0, dfr} = 4'b1110;
                default: {fr2, fr1, fr0, dfr} = 4'b1111;
            endcase
        end
    end

endmodule
