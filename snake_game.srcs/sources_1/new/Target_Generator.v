`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2016 01:26:22
// Design Name: 
// Module Name: Target_Generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Target_Generator(
        input CLK,
        input RESET,
        input reached_target,
        output [14:0] rand_target_address
    );
    
    reg [7:0] horizontal_shift_reg;
    reg [6:0] vertical_shift_reg;
    wire eight_first_xnor;
    wire eight_second_xnor;
    wire eight_third_xnor;
    wire seven_xnor;    
    
    assign rand_target_address = {horizontal_shift_reg, vertical_shift_reg};   
    
    assign eight_first_xnor = ((~horizontal_shift_reg[5])&&(~horizontal_shift_reg[7])) || ((horizontal_shift_reg[5])&&(horizontal_shift_reg[7]));
    assign eight_second_xnor = ((~horizontal_shift_reg[4])&&(~eight_first_xnor)) || ((horizontal_shift_reg[4])&&(eight_first_xnor));
    assign eight_third_xnor = ((~horizontal_shift_reg[3])&&(~eight_second_xnor)) || ((horizontal_shift_reg[3])&&(eight_second_xnor));
    assign seven_xnor = ((~vertical_shift_reg[5])&&(~vertical_shift_reg[6])) || ((vertical_shift_reg[5])&&(vertical_shift_reg[6]));
    
    always@(posedge CLK) begin
        if (RESET) begin
            horizontal_shift_reg <= 8'b00000000;
            vertical_shift_reg <= 7'b0000000;
        end
        else begin
            if (reached_target) begin
                if ({horizontal_shift_reg[6:0], eight_third_xnor} <= 160)
                    horizontal_shift_reg <= {horizontal_shift_reg[6:0], eight_third_xnor};
                else
                    horizontal_shift_reg <= {8'd80};
                    
                if ({vertical_shift_reg[5:0], seven_xnor} <= 120)
                    vertical_shift_reg <= {vertical_shift_reg[5:0], seven_xnor};
                else
                    vertical_shift_reg <= {7'd60};
            end  
            else begin
                horizontal_shift_reg <= horizontal_shift_reg;
                vertical_shift_reg <= vertical_shift_reg;
            end
        end
    end
    
endmodule