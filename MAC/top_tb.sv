`timescale 1ns / 1ns
// 
// Create Date: 09/04/2020 08:24:07 PM
// Design Name: 
// Module Name: top_tb
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


module top_tb(
    
    );
    shortreal a [11:0] = '{0.1,     0.2,    0.25,   -0.3,   0.4,    0.5,    0.55,   0.6,    -0.75,  0.8,    0.875,  0.9};
    shortreal b [11:0] = '{0.27,    -0.95,  0.125,  0.8,    0.875,  -0.75,  0.4,    0.6,    0.15,   0.25,   -0.4,   0.55};
    wire [15:0] A,B,C;
    bit clk;
    reg [1:0][15:0] B_d;
    reg [1:0][15:0] A_d,C_d;
    reg [11:0][15:0] multiplieradder;
    reg [5:0][15:0] addholder1;
    reg [2:0][15:0] addholder2;
    reg [15:0] addholder3;
    reg [15:0] finalholder;
    reg [4:0] counter,counter2;
    
    reg [15:0] A_adder_d0,A_adder_d1,A_adder_d2,A_adder_d3,A_adder_d4,A_adder_d5,A_adder_d6,A_adder_d7,A_adder_d8,A_adder_d9,A_adder_d10;
    reg [15:0] B_adder_d0,B_adder_d1,B_adder_d2,B_adder_d3,B_adder_d4,B_adder_d5,B_adder_d6,B_adder_d7,B_adder_d8,B_adder_d9,B_adder_d10;
    
    wire [15:0] C_adder0,C_adder1,C_adder2,C_adder3,C_adder4,C_adder5,C_adder6,C_adder7,C_adder8,C_adder9,C_adder10;
    wire [15:0] A_adder0,A_adder1,A_adder2,A_adder3,A_adder4,A_adder5,A_adder6,A_adder7,A_adder8,A_adder9,A_adder10;
    wire [15:0] B_adder0,B_adder1,B_adder2,B_adder3,B_adder4,B_adder5,B_adder6,B_adder7,B_adder8,B_adder9,B_adder10;

    //assign A = A_d;
    //assign B = B_d;
    //assign C = C_d;
    initial begin
        //A = 16'd0;
        //B = 16'd0;
        //C = 16'd0;
        //A_d = 16'b0011101100110011; //0.9
        //B_d = 16'b0011100001100110; //0.55
        A_d[0] = 16'b0011101100000000; //0.875
        B_d = 16'b1011011001100110; //-0.4
        //B_d[1] = 16'b1011010011001101; //-0.3
        counter = 0;
        counter2 =0;
        #310 $finish;
    end
    assign A_adder0 = A_adder_d0;
    assign B_adder0 = B_adder_d0;
    assign A_adder1 = A_adder_d1;
    assign B_adder1 = B_adder_d1;
    assign A_adder2 = A_adder_d2;
    assign B_adder2 = B_adder_d2;
    assign A_adder3 = A_adder_d3;
    assign B_adder3 = B_adder_d3;
    assign A_adder4 = A_adder_d4;
    assign B_adder4 = B_adder_d4;
    assign A_adder5 = A_adder_d5;
    assign B_adder5 = B_adder_d5;
    assign A_adder6 = A_adder_d6;
    assign B_adder6 = B_adder_d6;
    assign A_adder7 = A_adder_d7;
    assign B_adder7 = B_adder_d7;
    assign A_adder8 = A_adder_d8;
    assign B_adder8 = B_adder_d8;
    assign A_adder9 = A_adder_d9;
    assign B_adder9 = B_adder_d9;
    assign A_adder10 = A_adder_d10;
    assign B_adder10 = B_adder_d10;
    
    always
    #5 clk = ~clk;
    
    top uut(a,b,A,B,clk);   // convertes the real to bits and truncate it in 16 bit format from 32bit.
    multiplier uut2(A,B,clk,C);// multiplier module
    
    adder2 add0(A_adder0,B_adder0,C_adder0,clk);
    adder2 add1(A_adder1,B_adder1,C_adder1,clk);
    adder2 add2(A_adder2,B_adder2,C_adder2,clk);
    adder2 add3(A_adder3,B_adder3,C_adder3,clk);
    adder2 add4(A_adder4,B_adder4,C_adder4,clk);
    adder2 add5(A_adder5,B_adder5,C_adder5,clk);
    
    adder2 add6(A_adder6,B_adder6,C_adder6,clk);
    adder2 add7(A_adder7,B_adder7,C_adder7,clk);
    adder2 add8(A_adder8,B_adder8,C_adder8,clk);

    adder2 add9(A_adder9,B_adder9,C_adder9,clk);
    adder2 add10(A_adder10,B_adder10,C_adder10,clk);
    
    always @(posedge clk) begin
        $display("counter %d",counter);
        $display("counter2 %d",counter2);
        $display("A %b",A);
        $display("B %b",B);
        if ((counter>=3)&&(counter<15))multiplieradder[counter-3]= C;
        
        if (counter>=15)begin
            A_adder_d0 = multiplieradder[0];
            B_adder_d0 = multiplieradder[1];
            A_adder_d1 = multiplieradder[2];
            B_adder_d1 = multiplieradder[3];
            A_adder_d2 = multiplieradder[4];
            B_adder_d2 = multiplieradder[5];
            A_adder_d3 = multiplieradder[6];
            B_adder_d3 = multiplieradder[7];
            A_adder_d4 = multiplieradder[8];
            B_adder_d4 = multiplieradder[9];
            A_adder_d5 = multiplieradder[10];
            B_adder_d5 = multiplieradder[11];
            
            A_adder_d6 = addholder1[0];
            B_adder_d6 = addholder1[1];
            A_adder_d7 = addholder1[2];
            B_adder_d7 = addholder1[3];
            A_adder_d8 = addholder1[4];
            B_adder_d8 = addholder1[5];
            
            A_adder_d9 = addholder2[0];
            B_adder_d9 = addholder2[1];
            A_adder_d10 = addholder2[2];
            B_adder_d10 = addholder3;
            
        end
        addholder1[0]= C_adder0;
        addholder1[1]= C_adder1;
        addholder1[2]= C_adder2;
        addholder1[3]= C_adder3;
        addholder1[4]= C_adder4;
        addholder1[5]= C_adder5;
        
        addholder2[0]= C_adder6;
        addholder2[1]= C_adder7;
        addholder2[2]= C_adder8;
        
        addholder3= C_adder9;
        finalholder= C_adder10;


        //$display("A_adder_d %b",A_adder_d);
        //$display("B_adder_d %b",B_adder_d);
        //$display("C_adder %b",C_adder);
        
        $display("C %b",C);

        $display("multiplieradder[0] = %b",multiplieradder[0]); //0.4946
        $display("multiplieradder[1] = %b",multiplieradder[1]); //-0.3499
        $display("multiplieradder[2] = %b",multiplieradder[2]);//0.2
        $display("multiplieradder[3] = %b",multiplieradder[3]);//-0.1124
        $display("multiplieradder[4] = %b",multiplieradder[4]);//0.3594
        $display("multiplieradder[5] = %b",multiplieradder[5]);//0.2198
        $display("multiplieradder[6] = %b",multiplieradder[6]); //-0.375
        $display("multiplieradder[7] = %b",multiplieradder[7]); //0.3499
        $display("multiplieradder[8] = %b",multiplieradder[8]); //-0.2397
        $display("multiplieradder[9] = %b",multiplieradder[9]); //3.125E-2
        $display("multiplieradder[10] = %b",multiplieradder[10]); //-0.1898
        $display("multiplieradder[11] = %b",multiplieradder[11]); //2.696E-2

        $display("addholder1[0] = %b",addholder1[0]); // correct!! = 0.1448
        $display("addholder1[1] = %b",addholder1[1]); // correct!! = 0.0875
        $display("addholder1[2] = %b",addholder1[2]); // Correct!! = 0.579
        $display("addholder1[3] = %b",addholder1[3]); // Correct!! = -2.515E-2
        $display("addholder1[4] = %b",addholder1[4]); // Correct!! = -0.2085
        $display("addholder1[5] = %b",addholder1[5]); // CLOSE ENOUGH!! = -0.163 should be -0.1628

        $display("addholder2[0] = %b",addholder2[0]); // correct!! = 0.2323
        $display("addholder2[1] = %b",addholder2[1]); // CLOSE ENOUGH!! = 0.554 should be 0.5537
        $display("addholder2[2] = %b",addholder2[2]); // CLOSE ENOUGH!! = -0.3713 should be -0.3716
        
        $display("addholder3 = %b",addholder3); // CLOSE ENOUGH 0.786
        $display("finalholder = %b",finalholder); // CLOSE ENOUGH 0.415 SHOULD BE 0.4148
        
        
        if (counter>=15) ;
        else counter = counter+1;
    end
endmodule

module adder2( 
    input [15:0] A,
    input [15:0] B,
    output [15:0] C,
    input clk
    );
    
    reg [15:0] C_d,B_d;
    reg [4:0] S_exp,L_exp,S_exp_d,L_exp_d,out_L,out,C_exp,C_exp_d,B_exp_d,B_exp;
    reg [9:0] S_mantissa,L_mantissa;
    reg [11:0] C_mantissa,B_mantissa,C_mantissa_d2;
    wire [11:0] C_mantissa_d;
    reg [10:0] S_mantissa_d,L_mantissa_d,S_mantissa_d_sh;
    wire [10:0] S_mantissa_d_sh_sign;
    reg S_sig,L_sig,S_sig_d,L_sig_d,zeroflag,C_sig_d,B_sig_d;
    reg [9:0] testing,testing2;

    initial begin
        C_d = 0;
        B_d = 0;
        L_exp_d = 0;
        S_exp_d = 0;
        S_mantissa_d = 0;
        L_mantissa_d = 0;
        L_sig_d = 0;
        S_sig_d = 0;
        C_mantissa = 0;
        C_exp_d = 0;
        B_mantissa = 0;
        B_exp_d = 0;
        B_sig_d = 0;
    end

    assign C = C_d;
    
    always@(*) begin
        if (A==16'b0)begin
            C_d = B;
            zeroflag = 1'b1;
        end else if (B == 16'b0) begin
            C_d=A;
            zeroflag = 1'b1;
        end else begin
            zeroflag = 1'b0;
            testing = A[14:10]; testing2 = B[14:10];
            if ((testing)>(testing2)) begin
                L_exp = A[14:10]; L_mantissa = A[9:0]; L_sig = A[15];
                S_exp = B[14:10]; S_mantissa = B[9:0]; S_sig = B[15];
            end 
            else if (A[14:10] == B[14:10]) begin
                if (A[9:0] > B[9:0])begin
                    L_exp = A[14:10]; L_mantissa = A[9:0]; L_sig = A[15];
                    S_exp = B[14:10]; S_mantissa = B[9:0]; S_sig = B[15];
                end else begin
                    L_exp = B[14:10]; L_mantissa = B[9:0]; L_sig = B[15];
                    S_exp = A[14:10]; S_mantissa = A[9:0]; S_sig = A[15];
                end
            end else begin
                L_exp = B[14:10]; L_mantissa = B[9:0]; L_sig = B[15];
                S_exp = A[14:10]; S_mantissa = A[9:0]; S_sig = A[15];
            end
        end
    end

    always@(posedge(clk))begin
        if (zeroflag == 0) begin
            // going in
            L_exp_d<=L_exp;
            S_exp_d<=S_exp;
            S_mantissa_d<= {1'b1,S_mantissa};
            L_mantissa_d<= {1'b1,L_mantissa};
            L_sig_d <= L_sig;
            S_sig_d <= S_sig;

            // going out
            C_mantissa <=C_mantissa_d2[9:0];
            C_exp_d <= L_exp_d;
            C_sig_d <= L_sig_d;
            /*
            $display("");
            $display("A %b",A);
            $display("B %b",B);
            
            $display("S_mantissa %b",S_mantissa);
            $display("S_mantissa_d %b",S_mantissa_d);
            $display("S_mantissa_d_sh %b",S_mantissa_d_sh);
            $display("S_mantissa_d_sh_sign %b",S_mantissa_d_sh_sign);
            $display("L_mantissa_d %b",L_mantissa_d);
            $display("C_mantissa_d %b",C_mantissa_d);
            $display("C_mantissa_d[10:0] %b",C_mantissa_d[10:0]);
            $display("out %d",out);
            $display("C_mantissa_d2 %b",C_mantissa_d2);
            $display("should be %b",10'b1110011010);
            $display("C_exp_d %b",C_exp_d);
            $display("C_exp %b",C_exp);
            $display("should be %b",5'b01101);
            $display("C_sig_d %b",C_sig_d);
            $display("{C_sig_d,C_exp_d,C_mantissa[9:0]} %b",({C_sig_d,C_exp_d[4:0],C_mantissa[9:0]}));
            $display("C_mantissa %b",C_mantissa);
            $display("C_d %b",C_d);
            $display("should be %b",16'b0011011110011010);
            $display("L_exp_d - S_exp_d %b", (L_exp_d - S_exp_d));
            $display("~S_exp_d+16'd1 %b",(~S_exp_d+5'd1));
            $display("L_exp_d - S_exp_d %b", (L_exp_d - (~S_exp_d+5'd1)-5'd15));
            $display("");*/
            end
        end
    assign C_mantissa_d = S_mantissa_d_sh_sign + L_mantissa_d;
    assign S_mantissa_d_sh_sign = (L_sig_d^S_sig_d)?(~(S_mantissa_d>>(L_exp_d - S_exp_d)) +11'b1):(S_mantissa_d>>(L_exp_d - S_exp_d));// ahhh 2s complement

    always@(*)begin
        if (zeroflag == 0) begin
            casex(C_mantissa_d[10:0])
                11'b00000000001: out = 5'd10;
                11'b0000000001x: out = 5'd9;
                11'b000000001xx: out = 5'd8;
                11'b00000001xxx: out = 5'd7;
                11'b0000001xxxx: out = 5'd6;
                11'b000001xxxxx: out = 5'd5;
                11'b00001xxxxxx: out = 5'd4;
                11'b0001xxxxxxx: out = 5'd3;
                11'b001xxxxxxxx: out = 5'd2;
                11'b01xxxxxxxxx: out = 5'd1;
                11'b1xxxxxxxxxx: out = 5'd0;
                default : out =5'd10;
            endcase
            if ((L_sig_d^S_sig_d) == 1'b1)begin
                C_mantissa_d2 = C_mantissa_d<<(out);
                C_exp = (C_exp_d-out);
                C_d = ({C_sig_d,C_exp,(C_mantissa[9:0])});
            end else begin
            casex(C_mantissa_d[10:0])
                11'b01xxxxxxxxx: out = 5'd0;
                11'b1xxxxxxxxxx: out = 5'd1;
                default : out =5'd10;
            endcase
                //C_mantissa_d2 = C_mantissa_d>>(out);
                C_exp = (C_mantissa_d[11])?(C_exp_d+5'b1):(C_exp_d);
                C_d = ({C_sig_d,C_exp,(C_mantissa_d[11])?(C_mantissa_d[10:1]):(C_mantissa_d[9:0])});
            end
        end
    end
endmodule
