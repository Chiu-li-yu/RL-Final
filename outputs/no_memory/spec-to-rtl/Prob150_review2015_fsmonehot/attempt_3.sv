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
    // Define states based on provided one-hot encoding
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
        case (state)
            S:    next_state = d ? S1 : S;
            S1:   next_state = d ? S11 : S;
            S11:  next_state = d ? S11 : S110;
            S110: next_state = d ? B0 : S;
            B0:   next_state = B1;
            B1:   next_state = B2;
            B2:   next_state = B3;
            B3:   next_state = Count;
            Count:next_state = done_counting ? Wait : Count;
            Wait: next_state = ack ? S : Wait;
            default: next_state = S;
        endcase
    end

    // Assign output next-state flags
    assign S_next     = (next_state == S);
    assign S1_next    = (next_state == S1);
    assign B3_next    = (next_state == B3);
    assign Count_next = (next_state == Count);
    assign Wait_next  = (next_state == Wait);

    // Moore machine outputs
    assign shift_ena = (state == B0) || (state == B1) || (state == B2) || (state == B3);
    assign counting  = (state == Count);
    assign done      = (state == Wait);

endmodule
