//    This is testbench for UART Module
`timescale 1 ns/1 ps
//TB has neither inputs nor outputs
module Timer_tb ();

reg  Rst_TB;
reg  Clk_TB;
reg  [1:0] Clk_Freq_TB;
reg  Pause_Enable_T_TB;
reg  [2:0] Timer_Encoding_TB;
wire Time_Event_TB;
//wire time_out_s_TB;
//wire time_out_TB;
/////////////// Clk Generator ///////////////
localparam Period = 125;
always #(Period/2) Clk_TB = ~Clk_TB;     // Clk Frequency 8 MHz

/////////////// Initial BLock ///////////////
initial 
    begin
        // Save Waveform
        $dumpfile("Timer.vcd") ;
        $dumpvars; 
        Initialization ();
        Reset ();
        $display ("the initial time %t",$time);
        /*wait (time_out_TB == 1);
        $display ("the S time %t",$time);  // 1 minute   ----> 2 sec
        wait (time_out_s_TB == 1);
        $display ("the S time %t",$time);  // 1 minute   ----> 2 sec*/
        wait (Time_Event_TB == 1);
        $display ("the M time %t",$time);  // 1 minute   ----> 2 sec
        #2000
        Trial (1'b1);
        #2000
        Trial (1'b0);
        #2000
        $stop;
    end

/////////////// Reset BLock ///////////////
task Reset;
    begin
        Rst_TB=1'b1;
        #0.02
        Rst_TB=1'b0;
        #0.02
        Rst_TB=1'b1;
    end
endtask

/////////////// Initialization BLock ///////////////
task Initialization;
    begin
        Clk_TB=1'b1;
        Clk_Freq_TB=2'b11;
        Pause_Enable_T_TB = 1'b0;
        Timer_Encoding_TB=3'b000;
    end
endtask

/////////////// Trial BLock ///////////////
task Trial (input value);
    begin
        Pause_Enable_T_TB = value;
    end
endtask

/////////////// Module instantiation ///////////////
Timer U1 (
.Rst(Rst_TB),
.Clk(Clk_TB),
.Clk_Freq(Clk_Freq_TB),
.Pause_Enable_T(Pause_Enable_T_TB),
.Timer_Encoding(Timer_Encoding_TB),
.Time_Event(Time_Event_TB)
//.time_out_s (time_out_s_TB),
//.time_out(time_out_TB)
);

endmodule