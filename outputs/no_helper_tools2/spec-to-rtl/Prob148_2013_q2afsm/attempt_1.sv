module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);
    // States: A=00, B=01, C=10, D=11
    logic [1:0] state, next_state;

    always_ff @(posedge clk) begin
        if (!resetn)
            state <= 2'b00;
        else
            state <= next_state;
    end

    always_comb begin
        case (state)
            2'b00: begin // State A
                if (r[0]) next_state = 2'b01;
                else if (r[1]) next_state = 2'b10;
                else if (r[2]) next_state = 2'b11;
                else next_state = 2'b00;
            end
            2'b01: begin // State B
                if (r[0]) next_state = 2'b01;
                else next_state = 2'b00;
            end
            2'b10: begin // State C
                if (r[1]) next_state = 2'b10;
                else next_state = 2'b00;
            end
            2'b11: begin // State D
                // Based on "Once a device, i, is given a grant... continues to receive... as long as r[i]=1"
                // For D (g[2]), if r[2] stays 1, stay in D.
                if (r[2]) next_state = 2'b11;
                else next_state = 2'b00;
            end
            default: next_state = 2'b00;
        endcase
    end

    assign g[0] = (state == 2'b01);
    assign g[1] = (state == 2'b10);
    assign g[2] = (state == 2'b11);

endmodule
