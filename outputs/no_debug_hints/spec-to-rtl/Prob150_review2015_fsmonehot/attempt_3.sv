module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    parameter S    = 10'b0000000001;
    parameter S1   = 10'b0000000010;
    parameter S11  = 10'b0000000100;
    parameter S110 = 10'b0000001000;
    parameter B0   = 10'b0000010000;
    parameter B1   = 10'b0000100000;
    parameter B2   = 10'b0001000000;
    parameter B3   = 10'b0010000000;
    parameter Count = 10'b0100000000;
    parameter Wait  = 10'b1000000000;

    logic [9:0] next_state;

    always @(*) begin
        next_state = 10'b0;
        // S: 10'b0000000001
        // S1: 10'b0000000010
        // S11: 10'b0000000100
        // S110: 10'b0000001000
        // B0: 10'b0000010000
        // B1: 10'b0000100000
        // B2: 10'b0001000000
        // B3: 10'b0010000000
        // Count: 10'b0100000000
        // Wait: 10'b1000000000
        
        if (state == S) next_state = d ? S1 : S;
        else if (state == S1) next_state = d ? S11 : S;
        else if (state == S11) next_state = d ? S11 : S110;
        else if (state == S110) next_state = d ? B0 : S;
        else if (state == B0) next_state = B1;
        else if (state == B1) next_state = B2;
        else if (state == B2) next_state = B3;
        else if (state == B3) next_state = Count;
        else if (state == Count) next_state = done_counting ? Wait : Count;
        else if (state == Wait) next_state = ack ? S : Wait;
        else next_state = S;
    end

    assign B3_next = next_state[7];
    assign S_next = next_state[0];
    assign S1_next = next_state[1];
    assign Count_next = next_state[8];
    assign Wait_next = next_state[9];

    assign shift_ena = state[4] | state[5] | state[6] | state[7];
    assign counting  = state[8];
    assign done      = state[9];

endmodule
