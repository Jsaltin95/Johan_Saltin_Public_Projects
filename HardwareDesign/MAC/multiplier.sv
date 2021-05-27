`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2020 08:39:30 PM
// Design Name: 
// Module Name: multiplier
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


module multiplier(
    input reg [15:0] A,
    input reg [15:0] B,
    input clk,
    output reg [15:0] C
    );
    reg [15:0] A_intermediate,B_intermediate;
    reg [23:0] C_intermediate;
    reg [23:0] C_intermediate2;
    reg [31:0] check_lastbit;
    reg [4:0] remember;
    reg [1:0] activeState;
    reg [15:0] select;
    reg [4:0] out,out2;
    reg [5:0] C_before;
    reg [4:0] A_e, B_e;
    bit A_s,B_s;
    //initial begin
    //    A_s = 1'bx;
    //    B_s  =
    //end
    always @(posedge clk)
    begin
        //$display("A %b",A);
        //$display("B %b",B);
        A_s <= A[15];
        B_s <= B[15];
        A_e[4:0] <= A[14:10]; 
        B_e[4:0] <= B[14:10]; 
        
        //A_3 <= A_2;
        //B_3 <= B_2;
        
        //A_intermediate <= 16'd0; B_intermediate <= 16'd0; 
        A_intermediate[15:10] =6'b000001;B_intermediate[15:10] = 6'b000001; // Add the invisible 1. to the calculation.
        A_intermediate[9:0] <= A[9:0]; B_intermediate[9:0] <= B[9:0]; // Take the mantissa from the main variable
        //$display("A_intermediate %b",A_intermediate);
        //$display("B_intermediate %b",B_intermediate);     
        C_intermediate= (A_intermediate*B_intermediate);
        //$display("C_intermediate %b",C_intermediate);
        //$display("C_intermediate %b",C_intermediate);
        casex(C_intermediate)
            24'b000000000000000000000001: out = 5'd0;
            24'b00000000000000000000001x: out = 5'd1;
            24'b0000000000000000000001xx: out = 5'd2;
            24'b000000000000000000001xxx: out = 5'd3;
            24'b00000000000000000001xxxx: out = 5'd4;
            24'b0000000000000000001xxxxx: out = 5'd5;
            24'b000000000000000001xxxxxx: out = 5'd6;
            24'b00000000000000001xxxxxxx: out = 5'd7;
            24'b0000000000000001xxxxxxxx: out = 5'd8;
            24'b000000000000001xxxxxxxxx: out = 5'd9;
            24'b00000000000001xxxxxxxxxx: out = 5'd10;
            24'b0000000000001xxxxxxxxxxx: out = 5'd11;
            24'b000000000001xxxxxxxxxxxx: out = 5'd12;
            24'b00000000001xxxxxxxxxxxxx: out = 5'd13;
            24'b0000000001xxxxxxxxxxxxxx: out = 5'd14;
            24'b000000001xxxxxxxxxxxxxxx: out = 5'd15;
            24'b00000001xxxxxxxxxxxxxxxx: out = 5'd16;
            24'b0000001xxxxxxxxxxxxxxxxx: out = 5'd17;
            24'b000001xxxxxxxxxxxxxxxxxx: out = 5'd18;
            24'b00001xxxxxxxxxxxxxxxxxxx: out = 5'd19;
            24'b0001xxxxxxxxxxxxxxxxxxxx: out = 5'd20;
            24'b001xxxxxxxxxxxxxxxxxxxxx: out = 5'd21;
            24'b01xxxxxxxxxxxxxxxxxxxxxx: out = 5'd22;
            24'b1xxxxxxxxxxxxxxxxxxxxxxx: out = 5'd23;
            default : out =5'd10;
        endcase

        if (out == 5'd21)
            C_before [4:0] = (A_e[4:0])+(B_e[4:0])-5'd14; // (A - 15) +(B-15)-15 -> resulting exponent
        else if (out == 5'd20)
            C_before [4:0] = (A_e[4:0])+(B_e[4:0])-5'd15; // (A - 15) +(B-15)-15 -> resulting exponent
        else
             C_before [4:0] = 5'd0;

        C_before[5] = A_s^B_s;
        C[9:0] <= C_intermediate >> out-10;
        C[15:10] <= C_before[5:0];
        for(integer i=0; i<$size(C); i++) begin
         if(C[i]===1'bX) C=16'd0;
         if(C[i]===1'bZ) $display("C[%0d] is Z",C[i]);
        end
        //$display("C_m4 %b",C);
    end
endmodule
