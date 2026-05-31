module TopModule(
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    // Sequence:
    // 0: Initial
    // 1-5: 1s
    // 6: 0 after 5 ones (discard)
    // 7: Flag (01111110)
    // 8: Error (7+ ones)

    localparam S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5, SDISC = 4'd6, SFLAG = 4'd7, SERR = 4'd8;

    logic [3:0] state, next_state;

    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? SERR : SDISC;
            SDISC: next_state = in ? S1 : S0; // Should reset to S1 if in, or S0 if 0
            SFLAG: next_state = in ? S1 : S0;
            SERR: next_state = in ? SERR : S0;
            default: next_state = S0;
        endcase
    end

    // Correcting transition logic for SDISC/SFLAG:
    // When state is S5:
    // If in=0, we detected 0111110 -> discard, move to SDISC.
    // If in=1, we detected 0111111 -> 6 ones, move to SERR (wait for 0 to end error).

    // Let's re-map based on the FSM requirements:
    // 0111110: SDISC
    // 01111110: SFLAG
    // 01111111: SERR
    
    // Revised states:
    // S0: 0
    // S1: 01
    // S2: 011
    // S3: 0111
    // S4: 01111
    // S5: 011111
    // SDISC (0111110): Need to signal disc
    // SFLAG (01111110): Need to signal flag
    // SERR (01111111...): Need to signal err
    
    // Logic:
    // S5 --(0)--> SDISC --(1)--> S1 --(0)--> S0
    //              SDISC --(0)--> S0
    // S5 --(1)--> SERR --(1)--> SERR --(0)--> S0
    // S5 --(1)--> (wait, 01111110 is a flag)
    
    // Ah, the problem states 01111110 is a flag. 
    // Let's rethink.

    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? 4'd9 : SDISC; // S5 + 1 = 0111111
            4'd9: next_state = in ? SERR : SFLAG; // S5 + 1 + 1 = 01111111 (err) or 01111110 (flag)
            SDISC: next_state = in ? S1 : S0;
            SFLAG: next_state = in ? S1 : S0;
            SERR: next_state = in ? SERR : S0;
            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;
            disc <= (next_state == SDISC);
            flag <= (next_state == SFLAG);
            err <= (next_state == SERR);
        end
    end
endmodule
