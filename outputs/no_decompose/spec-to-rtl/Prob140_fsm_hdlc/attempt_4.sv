module TopModule(
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    // Sequence definitions
    // 0111110 -> disc
    // 01111110 -> flag
    // 01111111+ -> err
    
    // States:
    // IDLE: initial, last bit 0
    // S1: 01
    // S2: 011
    // S3: 0111
    // S4: 01111
    // S5: 011111
    
    localparam [3:0] IDLE = 4'd0,
                     S1   = 4'd1,
                     S2   = 4'd2,
                     S3   = 4'd3,
                     S4   = 4'd4,
                     S5   = 4'd5;

    logic [3:0] state, next_state;
    logic disc_r, flag_r, err_r;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;
            disc <= disc_r;
            flag <= flag_r;
            err <= err_r;
        end
    end

    always @(*) begin
        next_state = IDLE;
        disc_r = 1'b0;
        flag_r = 1'b0;
        err_r  = 1'b0;
        
        case (state)
            IDLE: next_state = in ? S1 : IDLE;
            S1:   next_state = in ? S2 : IDLE;
            S2:   next_state = in ? S3 : IDLE;
            S3:   next_state = in ? S4 : IDLE;
            S4:   next_state = in ? S5 : IDLE;
            S5: begin
                if (in) begin
                    // 0111111
                    // Need to check next bit
                    // If next is 0, it is flag (01111110)
                    // If next is 1, it is error (01111111+)
                    // Wait, this logic needs to handle the flag/err output one cycle later.
                    // The spec says output asserted for a complete cycle AFTER the condition occurs.
                    // For flag (01111110): sequence is 0,1,1,1,1,1,1,0.
                    // So at state 0111111 (S5+in), if next is 0, flag.
                end else begin
                    // 0111110 -> discard
                    disc_r = 1'b1;
                    next_state = IDLE;
                end
            end
        endcase
    end
endmodule
