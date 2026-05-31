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

    // One-hot state encoding
    localparam S    = 10'b0000000001;
    localparam S1   = 10'b0000000010;
    localparam S11  = 10'b0000000100;
    localparam S110 = 10'b0000001000;
    localparam B0   = 10'b0000010000;
    localparam B1   = 10'b0000100000;
    localparam B2   = 10'b0001000000;
    localparam B3   = 10'b0010000000;
    localparam Count= 10'b0100000000;
    localparam Wait = 10'b1000000000;

    logic [9:0] next_state;

    always @(*) begin
        next_state = 10'b0;
        case (1'b1)
            state[0]: next_state = d ? S1 : S;
            state[1]: next_state = d ? S11 : S;
            state[2]: next_state = d ? S11 : S110;
            state[3]: next_state = d ? B0 : S;
            state[4]: next_state = B1;
            state[5]: next_state = B2;
            state[6]: next_state = B3;
            state[7]: next_state = Count;
            state[8]: next_state = done_counting ? Wait : Count;
            state[9]: next_state = ack ? S : Wait;
            default:  next_state = S;
        endcase
    end

    assign S_next     = next_state[0];
    assign S1_next    = next_state[1];
    assign B3_next    = next_state[7];
    assign Count_next = next_state[8];
    assign Wait_next  = next_state[9];

    assign shift_ena  = state[4] | state[5] | state[6] | state[7];
    assign counting   = state[8];
    assign done       = state[9];

endmodule