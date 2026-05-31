module TopModule (
    input  clk,
    input  areset,
    input  x,
    output logic z
);
    // One-hot encoding
    localparam A = 2'b01;
    localparam B = 2'b10;

    logic [1:0] state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else begin
            case (state)
                A: state <= x ? B : A;
                B: state <= B;
                default: state <= A;
            endcase
        end
    end

    always_comb begin
        case (state)
            A: z = x;
            B: z = ~x;
            default: z = 1'b0;
        endcase
    end
endmodule
