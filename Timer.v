module Timer (
input  wire  Rst,
input  wire  Clk,
input  wire [1:0] Clk_Freq,
input  wire [2:0] Timer_Encoding,
input  wire Pause_Enable_T,
output reg  Time_Event
//output reg  time_out_s ,
//output reg  time_out
);

reg [15:0] Counter;
reg [15:0] Cycle_Counter;
reg [15:0] S_Counter;
reg [15:0] M_Counter;

// --------------Different Frequency---------------
localparam Clk_8MHz = 16'd122;
localparam Clk_4MHz = 16'd61;
localparam Clk_2MHz = 16'd31;
localparam Clk_1MHz = 16'd15;

reg  [15:0] D;
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

// --------------Different Timming---------------
localparam Min_1 = 16'd0;
localparam Min_2 = 16'd1;
localparam Min_5 = 16'd4;

reg  [15:0] D_2;
reg  [15:0] Q_2;

always @ (*)
begin
    case (Timer_Encoding) 
        3'b001:  D_2 = Min_2;
        3'b010:  D_2 = Min_5;
        3'b011:  D_2 = Min_2;
        3'b100:  D_2 = Min_1;
        default: D_2 = Min_1;
    endcase
end

always @ (posedge Clk or negedge Rst)
begin
    if (!Rst)
        Q_2 <= 16'd0;
    else 
        Q_2 <= D_2;
end


// --------------logic---------------

always @ (posedge Clk or negedge Rst)
begin

    if (!Rst)
        begin
            Counter       <= 16'h0000;
            Cycle_Counter <= 16'h0000;
            S_Counter     <= 16'h0000;
            M_Counter     <= 16'h0000;
            Time_Event    <= 1'b0;
            //time_out      <= 1'b0;
            //time_out_s    <= 1'b0;
        end

    else if (Pause_Enable_T ==1)
        begin
            Counter       <=  Counter;
            Cycle_Counter <=  Cycle_Counter;
            S_Counter     <=  S_Counter;
            M_Counter     <=  M_Counter;
        end

    else 
        begin
            if (Counter == 16'hFFFF)
                begin
                    Counter <= 16'h0000;
                    if (Cycle_Counter == Q )
                        begin
                            Cycle_Counter <= 16'h0000;
                            //time_out <= 1'b1;  //1  second
                            if (S_Counter == 16'd1)
                                begin
                                    S_Counter <=16'h0000;
                                    //time_out_s <=1'b1;            // --> 16'd1 = 2 sec  --> 16'd59 = 1 min
                                    //if (M_Counter == Q_2)
                                    if (M_Counter == 16'd0)
                                        begin
                                            M_Counter  <= 16'h0000;
                                            Time_Event <= 1'b1;    // --> 16'd0 = 1 min  
                                        end
                                    else
                                        begin
                                            Time_Event    <= 1'b0;
                                            M_Counter <= M_Counter + 1'b1;
                                        end
                                end 
                            else 
                                begin
                                    Time_Event    <= 1'b0;
                                    S_Counter <= S_Counter + 1'b1;
                                end
                        end
                    else
                        begin
                            Time_Event    <= 1'b0; 
                            Cycle_Counter <= Cycle_Counter + 1'b1;
                        end
                end
            else 
                begin
                    Time_Event    <= 1'b0;
                    Counter <= Counter + 1'b1;
                end
        end
end

endmodule
