module Timer (
input  wire  Rst,
input  wire  Clk,
input  wire [1:0] Clk_Freq,
output reg time_out,
output reg time_out_s
);

reg [15:0] Counter;
reg [15:0] Cycle_Counter;
reg [15:0] S_Counter;
reg [15:0] M_Counter;

localparam Clk_8MHz = 16'd122;
localparam Clk_4MHz = 16'd61;
localparam Clk_2MHz = 16'd31;
localparam Clk_1MHz = 16'd15;

reg [15:0] D;
reg  [15:0] Q;

always @ (*)
begin
    case (Clk_Freq) 
        2'b00 : D = Clk_1MHz;
        2'b01 : D = Clk_2MHz;
        2'b10 : D = Clk_4MHz;
        2'b11 : D = Clk_8MHz;
    endcase
end

always @ (posedge Clk or negedge Rst)
begin
    if (!Rst)
        Q <= 16'd0;
    else 
        Q <= D;
end

always @ (posedge Clk or negedge Rst)
begin
    if (!Rst)
        begin
            Counter <= 16'h0000;
            Cycle_Counter <= 16'h0000;
            S_Counter <= 16'h0000;
            M_Counter <= 16'h0000;
            time_out <= 1'b0;
            time_out_s <= 1'b0;
        end
    else 
        begin
            if (Counter == 16'hFFFF)
                begin
                    Counter <= 16'h0000;
                    if (Cycle_Counter == Q )
                        begin
                            Cycle_Counter <= 16'h0000;
                            time_out <= 1'b1;  //1  second
                            if (S_Counter == 16'd1)
                                begin
                                    S_Counter <=16'h0000;
                                    time_out_s <=1'b1;            // --> 16'd1 = 2 sec  --> 16'd59 = 1 min
                                end 
                            else 
                                S_Counter <= S_Counter + 1'b1;
                        end
                    else
                        Cycle_Counter <= Cycle_Counter + 1'b1;
                end
            else 
                Counter <= Counter + 1'b1;
        end
end

endmodule
