module FSM (
input wire Coin_In ,
input wire Double_Wash ,
input wire Timer_Pause ,
input wire Rst ,
input wire Clk_D ,
input wire Time_Event ,
output reg [2:0] Timer_Encoding ,
output reg Pause_Enable,
output reg Wash_Done
);

reg [2:0] State ,Next_State ;
reg Flag_DW ;
reg Flag_ID ;


localparam IDLE          = 3'b000;
localparam Filling_Water = 3'b001;
localparam Washing       = 3'b010;
localparam Rinsing       = 3'b011;
localparam Spinning      = 3'b100;


always @ (posedge Clk_D or negedge Rst)
    begin
        if (!Rst)
            State <= IDLE;
        else 
            State <= Next_State;
    end
 
always @ (*)
    begin
        Flag_DW = 1'b0;
        Flag_ID = 1'b0;
        Pause_Enable = 1'b0;
        case (State) 
            IDLE :  begin
                        if (Coin_In ==1'b1 && Flag_ID ==1'b0)
                            begin
                                Next_State = Filling_Water;
                                Flag_ID = 1'b1;
                            end
                        else if (Coin_In ==1'b1 && Timer_Pause ==1'b0 && Flag_ID ==1'b1)
                            Next_State = Spinning;
                        else 
                            Next_State = IDLE;
                    end
            Filling_Water : begin
                                if (Time_Event == 1'b1)
                                    Next_State = Washing;
                                else 
                                    Next_State = Filling_Water;
                            end
            Washing :       begin
                                if (Time_Event == 1'b1)
                                    Next_State = Rinsing;
                                else 
                                    Next_State = Washing;
                            end
            Rinsing :       begin
                                if (Time_Event == 1'b1 && Double_Wash ==1'b1 && Flag_DW==1'b0)
                                    begin
                                        Next_State = Washing;
                                        Flag_DW = 1'b1;
                                    end
                                else if (Time_Event == 1'b1 && Double_Wash ==1'b1 && Flag_DW==1'b1)
                                    begin
                                        Next_State = Spinning;
                                        Flag_DW = 1'b0; 
                                    end
                                else if (Time_Event == 1'b1 && Double_Wash ==1'b0)
                                    Next_State = Spinning;
                                else 
                                    Next_State = Rinsing;
                            end
            Spinning :      begin
                                if (Time_Event == 1'b1)
                                    begin
                                        Next_State = IDLE;
                                        Flag_ID = 1'b0;
                                        Pause_Enable = 1'b0;
                                    end
                                else if (Time_Event == 1'b0 && Timer_Pause == 1'b1 )
                                    begin
                                        Next_State = IDLE;
                                        Pause_Enable = 1'b1;
                                    end
                                else 
                                    begin
                                        Next_State = Spinning;
                                        Pause_Enable = 1'b0;
                                    end
                            end
            default :       begin
                                Next_State = IDLE;
                            end
        endcase
    end

always @ (*)
    begin
        Wash_Done = 1'b0;
        case (State) 
            IDLE :  begin
                        Timer_Encoding = IDLE;
                        if (Coin_In ==1'b1)
                            begin
                                Wash_Done =1'b0;
                            end
                        else 
                            begin
                                Wash_Done =1'b1;
                            end
                    end
            Filling_Water : begin
                                Wash_Done =1'b0;
                                Timer_Encoding = Filling_Water;
                            end
            Washing :   begin
                                Wash_Done =1'b0;
                                Timer_Encoding = Washing;
                        end
            Rinsing :   begin
                                Wash_Done =1'b0;
                                Timer_Encoding = Rinsing;
                        end
            Spinning :  begin
                                Timer_Encoding = Spinning;
                                if (Time_Event ==1'b1)
                                    Wash_Done = 1'b1;
                                else   
                                    Wash_Done = 1'b0;
                        end
            default :   begin
                            Wash_Done = 1'b0;
                            Timer_Encoding = IDLE;
                        end
        endcase
    end

endmodule