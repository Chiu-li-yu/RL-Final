
module TopModule (
    input logic d,
    input logic done_counting,
    input logic ack,
    input logic [9:0] state,
    output logic B3_next,
    output logic S_next,
    output logic S1_next,
    output logic Count_next,
    output logic Wait_next,
    output logic done,
    output logic counting,
    output logic shift_ena
);

    always @(*) begin
        // Next state logic
        // S_next: S->S (d=0), S1->S (d=0), S110->S (d=0), Wait->S (ack=1)
        S_next = (state[0] && !d) || (state[1] && !d) || (state[3] && !d) || (state[9] && ack);
        
        // S1_next: S->S1 (d=1)
        S1_next = (state[0] && d);
        
        // B3_next: B2->B3
        B3_next = state[6];
        
        // Count_next: B3->Count, Count->Count (done_counting=0)
        Count_next = state[7] || (state[8] && !done_counting);
        
        // Wait_next: Count->Wait (done_counting=1), Wait->Wait (ack=0)
        Wait_next = (state[8] && done_counting) || (state[9] && !ack);

        // Output logic
        shift_ena = state[4] || state[5] || state[6] || state[7];
        counting = state[8];
        done = state[9];
    end

endmodule
