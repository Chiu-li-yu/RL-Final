module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // Re-reading:
    // s[2], s[1], s[0] are sensors.
    // Above s[2]: s=3'b111 -> fr=0,0,0,0
    // Between s[2] & s[1]: s=3'b011 -> fr=0,0,1,dfr
    // Between s[1] & s[0]: s=3'b001 -> fr=0,1,1,dfr
    // Below s[0]: s=3'b000 -> fr=1,1,1,0
    
    // dfr: supplemental flow valve.
    // If sensor change indicates previous level > current level, dfr=1.
    // Reset: state where no sensors asserted (s=000) and all outputs asserted (fr2=1, fr1=1, fr0=1, dfr=1).

    logic [1:0] curr_level, last_level;

    always @(*) begin
        case(s)
            3'b111: curr_level = 2'd3;
            3'b011: curr_level = 2'd2;
            3'b001: curr_level = 2'd1;
            default: curr_level = 2'd0;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            last_level <= 2'd0;
        end else begin
            last_level <= curr_level;
        end
    end

    always @(*) begin
        if (reset) {fr2, fr1, fr0, dfr} = 4'b1111;
        else begin
            case(curr_level)
                2'd3: {fr2, fr1, fr0, dfr} = 4'b0000;
                2'd2: {fr2, fr1, fr0, dfr} = {2'b00, 1'b1, (last_level > curr_level)};
                2'd1: {fr2, fr1, fr0, dfr} = {1'b0, 2'b11, (last_level > curr_level)};
                2'd0: {fr2, fr1, fr0, dfr} = 4'b1110;
                default: {fr2, fr1, fr0, dfr} = 4'b0000;
            endcase
        end
    end

endmodule
