`timescale 1ns / 1ps

module main(input clk,
	output a, b, c, d, e, f, g, dp, 
    output [3:0] an ,
    output [3:0] keyb_row,
    input  [3:0] keyb_col,
    input btnU, //execute
    input btnC,
    output reset_out, 
    output OE,    
    output SH_CP,  
    output ST_CP, 
    output DS, 
    output [7:0] col_select 
    );
       
       
        //display  8x8
        logic [2:0] col_num;
        
        logic [0:7] [7:0] image_red = 
        {8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
        logic [0:7] [7:0]  image_green = 
        {8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
        logic [0:7] [7:0]  image_blue = 
        {8'b00000011, 8'b00000011, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};



display_8x8 display_8x8_0(
	.clk(clk),
	
	// RGB data for display current column
	.red_vect_in(image_red[col_num]),
	.green_vect_in(image_green[col_num]),
	.blue_vect_in(image_blue[col_num]),
	
	.col_data_capture(), // unused
	.col_num(col_num),
	
	// FPGA pins for display
	.reset_out(reset_out),
	.OE(OE),
	.SH_CP(SH_CP),
	.ST_CP(ST_CP),
	.DS(DS),
	.col_select(col_select)   
);
      


logic [3:0] key_value;
keypad4X4 keypad4X4_inst0(
	.clk(clk),
	.keyb_row(keyb_row), // just connect them to FPGA pins, row scanner
	.keyb_col(keyb_col), // just connect them to FPGA pins, column scanner
    .key_value(key_value), //user's output code for detected pressed key: row[1:0]_col[1:0]
    .key_valid(key_valid)  // user's output valid: if the key is pressed long enough (more than 20~40 ms), key_valid becomes '1' for just one clock cycle.
);
	
	logic [3:0] in0 = 4'h0; //initial value
    logic [3:0] in1 = 4'h0; //initial value
    logic [3:0] in2 = 4'h0; //initial value
    logic [3:0] in3 = 4'h0; //initial value
    
  logic [3:0] firstFloor = 4'b0000;
  logic [3:0] secondFloor = 4'b0000;
  logic [3:0] thirdFloor =4'b0000;
 

logic timeReset = 0;    
logic execute = 0;
 logic clk_out;
       logic [3:0] int1; //timer,7 segment
       logic [3:0]int2;
       logic [3:0] int3;
       logic [3:0 ]int0 = 4'b1111; 
       logic [3:0 ]direc = 4'b1010; 
 ClockDivider  clock( clk, clk_out);
timer t( execute,timeReset,clk_out,int0,int1,int2,int3, direc);
SevSeg_4digit SevSeg_4digit_inst0( clk, direc, int1, int2, int3, a, b, c, d, e, f, g, dp, an );


logic goUp = 1;
logic goDown = 0;
logic elePas = 3'b000;

logic [28:0] counter = {29{1'b0}};
always@ (posedge clk)
begin
if ((key_valid == 1'b1) && (execute == 0))
            begin
                case(key_value) 
                4'b01_01:begin
                    if (firstFloor != 0)
                        begin
                                            if(firstFloor == 12)
                                            begin
                                                image_red[7][3] = 0;
                                                firstFloor = firstFloor -1;
                                            end
                                            else if(firstFloor == 11)
                                            begin
                                                image_red[7][2] = 0;
                                                firstFloor = firstFloor -1;
                                            end
                                            else if(firstFloor == 10)
                                            begin
                                                image_red[6][3] = 0;
                                                firstFloor = firstFloor -1;
                                            end
                                            else if(firstFloor == 9)
                                            begin
                                                image_red[6][2] = 0;
                                                firstFloor = firstFloor -1;
                                            end
                                            else if(firstFloor == 8)
                                            begin    
                                                image_red[5][3] = 0;
                                                firstFloor = firstFloor -1;
                                            end
                                            else if(firstFloor == 7)
                                            begin   
                                                image_red[5][2] = 0;
                                                firstFloor = firstFloor -1;
                                            end
                                            else if(firstFloor == 6)
                                            begin
                                                image_red[4][3] = 0;
                                                firstFloor = firstFloor -1;
                                            end
                                            else if(firstFloor == 5)
                                            begin
                                                image_red[4][2] = 0;
                                                firstFloor = firstFloor -1;
                                            end
                                            else if(firstFloor == 4)
                                            begin
                                                image_red[3][3] = 0;
                                                firstFloor = firstFloor -1;
                                            end
                                            else if(firstFloor == 3)
                                            begin
                                                image_red[3][2] = 0;
                                                firstFloor = firstFloor -1;
                                            end
                                            else if(firstFloor == 2)
                                            begin
                                                image_red[2][3] = 0;
                                                firstFloor = firstFloor -1;
                                            end
                                            else if(firstFloor == 1)
                                            begin
                                                image_red[2][2] = 0;
                                                firstFloor = firstFloor -1;
                                            end
                                        end        
                                        end             
                4'b01_00: begin
                    if (firstFloor != 12)
                    begin
                        if(firstFloor == 0)
                        begin
                            image_red[2][2] = 1;
                            firstFloor = firstFloor +1;
                        end
                        else if(firstFloor == 1)
                        begin
                            image_red[2][3] = 1;
                            firstFloor = firstFloor +1;
                        end
                        else if(firstFloor == 2)
                        begin
                            image_red[3][2] = 1;
                            firstFloor = firstFloor +1;
                        end
                        else if(firstFloor == 3)
                        begin
                            image_red[3][3] = 1;
                            firstFloor = firstFloor +1;
                        end
                        else if(firstFloor == 4)
                        begin    
                            image_red[4][2] = 1;
                            firstFloor = firstFloor +1;
                        end
                        else if(firstFloor == 5)
                        begin   
                            image_red[4][3] = 1;
                            firstFloor = firstFloor +1;
                        end
                        else if(firstFloor == 6)
                        begin
                            image_red[5][2] = 1;
                            firstFloor = firstFloor +1;
                        end
                        else if(firstFloor == 7)
                        begin
                            image_red[5][3] = 1;
                            firstFloor = firstFloor +1;
                        end
                        else if(firstFloor == 8)
                        begin
                            image_red[6][2] = 1;
                            firstFloor = firstFloor +1;
                        end
                        else if(firstFloor == 9)
                        begin
                            image_red[6][3] = 1;
                            firstFloor = firstFloor +1;
                        end
                        else if(firstFloor == 10)
                        begin
                            image_red[7][2] = 1;
                            firstFloor = firstFloor +1;
                        end
                        else if(firstFloor == 11)
                        begin
                            image_red[7][3] = 1;
                            firstFloor = firstFloor +1;
                        end
                       
                    end        
                    end  
                4'b10_01:begin
                    if (secondFloor != 0)
                    begin
                         if(secondFloor == 12)
                          begin
                          image_red[7][5] = 0;
                          secondFloor = secondFloor - 1;
                          end
                          else if(secondFloor == 11)
                          begin
                          image_red[7][4] = 0;
                          secondFloor = secondFloor - 1;
                          end
                          else if(secondFloor == 10)
                          begin
                          image_red[6][5] = 0;
                          secondFloor = secondFloor - 1;
                          end
                          else if(secondFloor == 9)
                          begin
                          image_red[6][4] = 0;
                            secondFloor = secondFloor - 1;
                                                                end
                                                                else if(secondFloor == 8)
                                                                begin    
                                                                    image_red[5][5] = 0;
                                                                    secondFloor = secondFloor - 1;
                                                                end
                                                                else if(secondFloor == 7)
                                                                begin   
                                                                    image_red[5][4] = 0;
                                                                    secondFloor = secondFloor - 1;
                                                                end
                                                                else if(secondFloor == 6)
                                                                begin
                                                                    image_red[4][5] = 0;
                                                                    secondFloor = secondFloor - 1;
                                                                end
                                                                else if(secondFloor == 5)
                                                                begin
                                                                    image_red[4][4] = 0;
                                                                    secondFloor = secondFloor - 1;
                                                                end
                                                                else if(secondFloor == 4)
                                                                begin
                                                                    image_red[3][5] = 0;
                                                                    secondFloor = secondFloor - 1;
                                                                end
                                                                else if(secondFloor == 3)
                                                                begin
                                                                    image_red[3][4] = 0;
                                                                    secondFloor = secondFloor - 1;
                                                                end
                                                                else if(secondFloor == 2)
                                                                begin
                                                                    image_red[2][5] = 0;
                                                                   secondFloor = secondFloor - 1;
                                                                end
                                                                else if(secondFloor == 1)
                                                                begin
                                                                    image_red[2][4] = 0;
                                                                    secondFloor = secondFloor - 1;
                                                                end
                                                            end        
                                                            end    
                        
                4'b10_00:begin
                    if (secondFloor != 12)
                    begin
                                            if(secondFloor == 0)
                                            begin
                                                image_red[2][4] = 1;
                                                secondFloor = secondFloor + 1; 
                                            end
                                            else if(secondFloor == 1)
                                            begin
                                                image_red[2][5] = 1;
                                                secondFloor = secondFloor + 1; 
                                            end
                                            else if(secondFloor == 2)
                                            begin
                                                image_red[3][4] = 1;
                                                secondFloor = secondFloor + 1; 
                                            end
                                            else if(secondFloor == 3)
                                            begin
                                                image_red[3][5] = 1;
                                                secondFloor = secondFloor + 1; 
                                            end
                                            else if(secondFloor == 4)
                                            begin    
                                                image_red[4][4] = 1;
                                                secondFloor = secondFloor + 1; 
                                            end
                                            else if(secondFloor == 5)
                                            begin   
                                                image_red[4][5] = 1;
                                                secondFloor = secondFloor + 1; 
                                            end
                                            else if(secondFloor == 6)
                                            begin
                                                image_red[5][4] = 1;
                                                secondFloor = secondFloor + 1; 
                                            end
                                            else if(secondFloor == 7)
                                            begin
                                                image_red[5][5] = 1;
                                                secondFloor = secondFloor + 1; 
                                            end
                                            else if(secondFloor == 8)
                                            begin
                                                image_red[6][4] = 1;
                                                secondFloor = secondFloor + 1; 
                                            end
                                            else if(secondFloor == 9)
                                            begin
                                                image_red[6][5] = 1;
                                                secondFloor = secondFloor + 1; 
                                            end
                                            else if(secondFloor == 10)
                                            begin
                                                image_red[7][4] = 1;
                                                secondFloor = secondFloor + 1; 
                                            end
                                            else if(secondFloor == 11)
                                            begin
                                                image_red[7][5] = 1;
                                                secondFloor = secondFloor + 1; 
                                            end
                                        end        
                                        end 
                           
                4'b11_01:begin 
                    if (thirdFloor != 0)
                    begin
                    if(thirdFloor == 12)
                    begin
                        image_red[7][7] = 0;
                        thirdFloor = thirdFloor - 1;
                    end
                    else if(thirdFloor == 11)
                    begin
                        image_red[7][6] = 0;
                        thirdFloor = thirdFloor - 1;
                    end
                    else if(thirdFloor == 10)
                    begin
                        image_red[6][7] = 0;
                        thirdFloor = thirdFloor - 1;
                    end
                    else if(thirdFloor == 9)
                    begin
                        image_red[6][6] = 0;
                        thirdFloor = thirdFloor - 1;
                    end
                    else if(thirdFloor == 8)
                    begin    
                        image_red[5][7] = 0;
                        thirdFloor = thirdFloor - 1;
                    end
                    else if(thirdFloor == 7)
                    begin   
                        image_red[5][6] = 0;
                        thirdFloor = thirdFloor - 1;
                    end
                    else if(thirdFloor == 6)
                    begin
                        image_red[4][7] = 0;
                        thirdFloor = thirdFloor - 1;
                    end
                    else if(thirdFloor == 5)
                    begin
                        image_red[4][6] = 0;
                        thirdFloor = thirdFloor - 1;
                    end
                    else if(thirdFloor == 4)
                    begin
                        image_red[3][7] = 0;
                        thirdFloor = thirdFloor - 1;
                    end
                    else if(thirdFloor == 3)
                    begin
                        image_red[3][6] = 0;
                        thirdFloor = thirdFloor - 1;
                    end
                    else if(thirdFloor == 2)
                    begin
                        image_red[2][7] = 0;
                       thirdFloor = thirdFloor - 1;
                    end
                    else if(thirdFloor == 1)
                    begin
                        image_red[2][6] = 0;
                        thirdFloor = thirdFloor - 1;
                    end
                end        
                end 
                        
                4'b11_00:begin
                    if (thirdFloor != 12)
                    begin
                                                                if(thirdFloor == 0)
                                                                begin
                                                                    image_red[2][6] = 1;
                                                                    thirdFloor = thirdFloor + 1; 
                                                                end
                                                                else if(thirdFloor == 1)
                                                                begin
                                                                    image_red[2][7] = 1;
                                                                    thirdFloor = thirdFloor + 1; 
                                                                end
                                                                else if(thirdFloor == 2)
                                                                begin
                                                                    image_red[3][6] = 1;
                                                                    thirdFloor = thirdFloor + 1; 
                                                                end
                                                                else if(thirdFloor == 3)
                                                                begin
                                                                    image_red[3][7] = 1;
                                                                    thirdFloor = thirdFloor + 1; 
                                                                end
                                                                else if(thirdFloor == 4)
                                                                begin    
                                                                    image_red[4][6] = 1;
                                                                    thirdFloor = thirdFloor + 1; 
                                                                end
                                                                else if(thirdFloor == 5)
                                                                begin   
                                                                    image_red[4][7] = 1;
                                                                   thirdFloor = thirdFloor + 1;
                                                                end
                                                                else if(thirdFloor == 6)
                                                                begin
                                                                    image_red[5][6] = 1;
                                                                   thirdFloor = thirdFloor + 1;
                                                                end
                                                                else if(thirdFloor == 7)
                                                                begin
                                                                    image_red[5][7] = 1;
                                                                    thirdFloor = thirdFloor + 1; 
                                                                end
                                                                else if(thirdFloor == 8)
                                                                begin
                                                                    image_red[6][6] = 1;
                                                                    thirdFloor = thirdFloor + 1;
                                                                end
                                                                else if(thirdFloor == 9)
                                                                begin
                                                                    image_red[6][7] = 1;
                                                                   thirdFloor = thirdFloor + 1; 
                                                                end
                                                                else if(thirdFloor == 10)
                                                                begin
                                                                    image_red[7][6] = 1;
                                                                    thirdFloor = thirdFloor + 1; 
                                                                end
                                                                else if(thirdFloor == 11)
                                                                begin
                                                                    image_red[7][7] = 1;
                                                                    thirdFloor = thirdFloor + 1; 
                                                                end
                                                            end        
                                                            end 
            
    endcase
    end
    
    if(btnU == 1'b1)
    begin
        execute <= 1;
    end
    
    if(btnC == 1'b1)
    begin
        timeReset <= 1;
    end
    
    if(counter == 49_999_999)
        timeReset <= 0;
    
	counter <= counter + 1;
    	
	if (execute)
	begin
	
	if(((thirdFloor + secondFloor + firstFloor)==0) && (((image_blue[1][1]) == 1)||(image_red[0][0] == 1))&& (counter == ((49_999_999) * 4)) ) //&& (counter == ((49_999_999) * 2))
	begin
	   counter <= {29{1'b0}};
	   goUp <= 0;
	   goDown <= 0;
	   image_blue[0] <= 8'b00000011;
       image_blue[1] <= 8'b00000011;
       image_red[0] <= 8'b00000000;
       image_red[1] <= 8'b00000000;
       elePas <= 0;
	end
	if(goUp == 1)
	   int0 <= 4'b1111;
	else if(goDown == 1)
	   int0 <= 4'b0000;
	else
	   int0 <= 4'b1000;
	
     if((goDown ==1) && ((image_blue[1][1] ==1) || (image_red[0][0] == 1)) && ((firstFloor >0) || (secondFloor > 0) || (thirdFloor >0)) && (counter == ((49_999_999) * 4)))
	begin
	counter <= {29{1'b0}};
	image_blue[0] <= 8'b00000011;
    image_blue[1] <= 8'b00000011;
    image_red[0] <= 8'b00000000;
    image_red[1] <= 8'b00000000;
    goUp <= 1;
    goDown <= 0;
    elePas <= 0;
	end
    
    if((goUp == 1) && (counter == ((49_999_999) * 6)) &&((thirdFloor + secondFloor + firstFloor)>0 ) &&(elePas == 0) &&
    ((image_red[0][2] !=1)&&(image_red[0][4] !=1) && (image_red[0][6] !=1)))
    begin
        counter <= {29{1'b0}};
        image_blue[0] <= image_blue[0] * 4;
        image_blue[1] <= image_blue[1] * 4;
        
    end
    
    if((goDown == 1 ) && ((image_blue[0][0] != 1)||(image_red[0][0] !=1)) &&(counter == ((49_999_999) * 6)))
    begin
        counter <= {29{1'b0}};
        image_blue[0] <= image_blue[0] / 4;
        image_blue[1] <= image_blue[1] / 4;
        image_red[0] <= image_red[0] / 4;
        image_red[1] <= image_red[1] / 4;
       
    end

   if((thirdFloor == 4) && (image_blue[0][6] == 1) && (counter == ((49_999_999) * 4)))
   begin 
           counter <= {29{1'b0}};
           image_blue[0] <= 8'b00000000;
           image_blue[1] <= 8'b00000000; 
           image_red[0] <= 8'b11000000;
           image_red[1] <= 8'b11000000;
           goDown <= 1;
           goUp <= 0;
           image_red[2][6] <= 0;
           image_red[2][7] <= 0;
           image_red[3][6] <= 0;
           image_red[3][7] <= 0;
           thirdFloor <=  0;
           elePas <= 4;
   end
    else if((thirdFloor == 5) &&( image_blue[0][6] == 1) && (counter == ((49_999_999) * 4)))
    begin
                counter <= {29{1'b0}};
               image_blue[0] <= 8'b00000000;
               image_blue[1] <= 8'b00000000; 
               image_red[0] <= 8'b11000000;
               image_red[1] <= 8'b11000000;
               goDown <= 1;
               goUp <= 0;
               image_red[3][7] <= 0;
               image_red[3][6] <= 0;
               image_red[2][7] <= 0;
               thirdFloor <= 1;
               elePas <= 4;
    end
    else if((thirdFloor == 6) && (image_blue[0][6] == 1)&& (counter == ((49_999_999) * 4)))
    begin
        counter <= {29{1'b0}};
        image_blue[0] <= 8'b00000000;
        image_blue[1] <= 8'b00000000; 
        image_red[0] <= 8'b11000000;
        image_red[1] <= 8'b11000000;
        goDown <= 1;
        goUp <= 0;
        image_red[4][6] <= 0;
        image_red[4][7] <= 0;
        image_red[3][6] <= 0;
        image_red[3][7] <= 0;
        thirdFloor <=  2;
        elePas <= 4;
        end
    else if((thirdFloor == 7) && (image_blue[0][6] == 1)&& (counter == ((49_999_999) * 4)))
    begin
        counter <= {29{1'b0}}; 
        image_blue[0] <= 8'b00000000;
        image_blue[1] <= 8'b00000000; 
        image_red[0] <= 8'b11000000;
        image_red[1] <= 8'b11000000;
        goDown <= 1;
        goUp <= 0;
        image_red[4][6] <= 0;
        image_red[4][7] <= 0;
        image_red[5][6] <= 0;
        image_red[3][7] <= 0;
        thirdFloor <= 3;
        elePas <= 4;
    end
    else if((thirdFloor == 8) && (image_blue[0][6] == 1)&& (counter == ((49_999_999) * 4)))
    begin
            counter <= {29{1'b0}};
            image_blue[0] <= 8'b00000000;
            image_blue[1] <= 8'b00000000; 
            image_red[0] <= 8'b11000000;
            image_red[1] <= 8'b11000000;
            goDown <= 1;
            goUp <= 0;
            image_red[4][6] <= 0;
            image_red[4][7] <= 0;
            image_red[5][6] <= 0;
            image_red[5][7] <= 0;
            thirdFloor <=  4;
            elePas <= 4;
    end
    else if((thirdFloor == 9) && (image_blue[0][6] == 1)&& (counter == ((49_999_999) * 4))) 
    begin
        counter <= {29{1'b0}};
        image_blue[0] <= 8'b00000000;
        image_blue[1] <= 8'b00000000; 
        image_red[0] <= 8'b11000000;
        image_red[1] <= 8'b11000000;
        goDown <= 1;
        goUp <= 0;
        image_red[6][6] <= 0;
        image_red[4][7] <= 0;
        image_red[5][6] <= 0;
        image_red[5][7] <= 0;
        thirdFloor <= 5;
        elePas <= 4;
    end
    else if((thirdFloor == 10) && (image_blue[0][6] == 1)&& (counter == ((49_999_999) * 4)))
    begin
        counter <= {29{1'b0}};
        image_blue[0] <= 8'b00000000;
        image_blue[1] <= 8'b00000000; 
        image_red[0] <= 8'b11000000;
        image_red[1] <= 8'b11000000;
        goDown <= 1;
        goUp <= 0;
        image_red[6][6] <= 0;
        image_red[6][7] <= 0;
        image_red[5][6] <= 0;
        image_red[5][7] <= 0;
        thirdFloor <=  6;
        elePas <= 4;
    end   
    else if((thirdFloor == 11) && (image_blue[0][6] == 1)&& (counter == ((49_999_999) * 4)))
    begin
        counter <= {29{1'b0}};
        image_blue[0] <= 8'b00000000;
        image_blue[1] <= 8'b00000000; 
        image_red[0] <= 8'b11000000;
        image_red[1] <= 8'b11000000;
        goDown <= 1;
        goUp <= 0;
        image_red[7][6] <= 0;
        image_red[5][7] <= 0;
        image_red[6][6] <= 0;
        image_red[6][7] <= 0;
        thirdFloor <= 7;
        elePas <= 4;
    end  
    else if((thirdFloor == 12) && (image_blue[0][6] == 1)&& (counter == ((49_999_999) * 4))) 
    begin
        counter <= {29{1'b0}};
        image_blue[0] <= 8'b00000000;
        image_blue[1] <= 8'b00000000; 
        image_red[0] <= 8'b11000000;
        image_red[1] <= 8'b11000000;
        goDown <= 1;
        goUp <= 0;
        image_red[7][6] <= 0;
        image_red[7][7] <= 0;
        image_red[6][6] <= 0;
        image_red[6][7] <= 0;
        thirdFloor <=  8;
        elePas <= 4;
    end //end of third floor
    
    else if(( secondFloor >= 4 ) && (image_blue[0][4] == 1)&& (counter == ((49_999_999) * 4)))
    begin
        counter <= {29{1'b0}};
        image_blue[0] <= 8'b00000000;
        image_blue[1] <= 8'b00000000; 
        image_red[0] <= 8'b00110000;
        image_red[1] <= 8'b00110000;
        goDown <= 1;
        goUp <= 0;
        elePas <= 4;
    
    if(secondFloor ==4)
     begin
       image_red[2][4] <= 0;
       image_red[2][5] <= 0;
       image_red[3][4] <= 0;
       image_red[3][5] <= 0;
       secondFloor <=  0;
       end
    else if(secondFloor ==5)
    begin
        image_red[4][4] <= 0;
        image_red[4][5] <= 0;
        image_red[3][4] <= 0;
        image_red[2][5] <= 0;
        secondFloor <= 1;
      end
    else if(secondFloor ==6)
    begin
        image_red[4][4] <= 0;
        image_red[4][5] <= 0;
        image_red[3][4] <= 0;
        image_red[3][5] <= 0;
        secondFloor <= 2;
    end
    else if(secondFloor ==7)
    begin
        image_red[4][4] <= 0;
        image_red[4][5] <= 0;
        image_red[5][4] <= 0;
        image_red[3][5] <= 0;
        secondFloor <= 3;
    end
    else if(secondFloor ==8)
    begin
        image_red[4][4] <= 0;
        image_red[4][5] <= 0;
        image_red[5][4] <= 0;
        image_red[5][5] <= 0;
        secondFloor <=  4;
    end
    else if(secondFloor ==9)
    begin
        image_red[6][4] <= 0;
        image_red[4][5] <= 0;
        image_red[5][4] <= 0;
        image_red[5][5] <= 0;
        secondFloor <=  5;
    end
    else if(secondFloor ==10)
    begin
        image_red[6][4] <= 0;
        image_red[6][5] <= 0;
        image_red[5][4] <= 0;
        image_red[5][5] <= 0;
        secondFloor <=  6;
    end
    else if(secondFloor ==11)
    begin
        image_red[7][4] <= 0;
        image_red[5][5] <= 0;
        image_red[6][4] <= 0;
        image_red[6][5] <= 0;
        secondFloor <=  7;
    end
    else if(secondFloor ==12)
    begin
        image_red[7][4] <= 0;
        image_red[7][5] <= 0;
        image_red[6][4] <= 0;
        image_red[6][5] <= 0;
        secondFloor <=  8;
    end
    
    end // end of 2nd >= 4
    
   else if(( firstFloor >= 4 ) && ( image_blue[0][4] == 1) && (counter == ((49_999_999) * 4)))
   begin
        counter <= {29{1'b0}};
       image_blue[0] <= 8'b00000000;
       image_blue[1] <= 8'b00000000; 
       image_red[0] <= 8'b00001100;
       image_red[1] <= 8'b00001100;
       goDown <= 1;
       goUp <= 0;
       elePas <= 4;
   
    if(firstFloor ==4)
    begin
      image_red[2][2] <= 0;
      image_red[2][3] <= 0;
      image_red[3][2] <= 0;
      image_red[3][3] <= 0;
      firstFloor <= 0;
      end
   else if(firstFloor ==5)
   begin
       image_red[4][2] <= 0;
       image_red[2][3] <= 0;
       image_red[3][2] <= 0;
       image_red[3][3] <= 0;
       firstFloor <= 1;
     end
   else if(firstFloor ==6)
   begin
       image_red[4][2] <= 0;
       image_red[4][3] <= 0;
       image_red[3][2] <= 0;
       image_red[3][3] <= 0;
       firstFloor <= 2;
   end
   else if(firstFloor ==7)
   begin
       image_red[4][2] <= 0;
       image_red[4][3] <= 0;
       image_red[5][2] <= 0;
       image_red[3][3] <= 0;
       firstFloor <= 3;
   end
   else if(firstFloor ==8)
   begin
       image_red[4][2] <= 0;
       image_red[4][3] <= 0;
       image_red[5][2] <= 0;
       image_red[5][3] <= 0;
       firstFloor <= 4;
   end
   else if(firstFloor ==9)
   begin
       image_red[6][2] <= 0;
       image_red[4][3] <= 0;
       image_red[5][2] <= 0;
       image_red[5][3] <= 0;
       firstFloor <= 5;
   end
   else if(firstFloor ==10)
   begin
       image_red[6][2] <= 0;
       image_red[6][3] <= 0;
       image_red[5][2] <= 0;
       image_red[5][3] <= 0;
       firstFloor <= 6;
   end
   else if(firstFloor ==11)
   begin
       image_red[7][2] <= 0;
       image_red[5][3] <= 0;
       image_red[6][2] <= 0;
       image_red[6][3] <= 0;
       firstFloor <= 7;
   end
   else if(firstFloor ==12)
   begin
       image_red[7][2] <= 0;
       image_red[7][3] <= 0;
       image_red[6][2] <= 0;
       image_red[6][3] <= 0;
       firstFloor <= 8;
   end
       
   end // end of 1st >= 4 
  
  else if((thirdFloor > 0 ) && (thirdFloor <4) && ( image_blue[0][6] == 1) && (counter == ((49_999_999) * 4)))
   begin 
        counter <= {29{1'b0}};
       goUp = 0;
       goDown = 1;
       thirdFloor <= 0;
       if(thirdFloor == 3)
       begin
            image_blue[0] <= 8'b00000000;
            image_blue[1] <= 8'b10000000;
            image_red[0] <= 8'b11000000;
            image_red[1] <= 8'b01000000;
            image_red[2][6] <= 0;
            image_red[2][7] <= 0;
            image_red[3][6] <= 0;
            elePas <= 3;
            
       end
       else if(thirdFloor == 2)
       begin
       image_blue[0] <= 8'b00000000;
       image_blue[1] <= 8'b11000000;
       image_red[0] <= 8'b11000000;
       image_red[1] <= 8'b00000000;
       image_red[2][6] <= 0;
       image_red[2][7] <= 0;
       elePas <= 2;
    
       end
      else if(thirdFloor == 1)
       begin
       image_blue[0] <= 8'b10000000;
       image_blue[1] <= 8'b11000000;
       image_red[0] <= 8'b01000000;
       image_red[1] <= 8'b00000000;
       image_red[2][6] <= 0;
       elePas <= 1;
      
       end
   end 
  else if((secondFloor > 0 ) && (secondFloor <4) && (thirdFloor == 0) &&(elePas == 0) && ( image_blue[0][4] == 1) && (counter == ((49_999_999) * 4)))
    begin
        counter <= {29{1'b0}}; 
        goUp = 0;
        goDown = 1;

        if(secondFloor == 3)
        begin
             image_blue[0] <= 8'b00000000;
             image_blue[1] <= 8'b00100000;
             image_red[0] <= 8'b00110000;
             image_red[1] <= 8'b00010000;
             image_red[2][4] <= 0;
             image_red[2][5] <= 0;
             image_red[3][4] <= 0;
             secondFloor <=0;
             elePas <= 3;
        end
        else if(secondFloor == 2)
        begin
        image_blue[0] <= 8'b00000000;
        image_blue[1] <= 8'b00110000;
        image_red[0] <= 8'b00110000;
        image_red[1] <= 8'b00000000;
        image_red[2][4] <= 0;
        image_red[2][5] <= 0;
        secondFloor <=0;
        elePas <= 2;
        end
        else if(secondFloor == 1)
        begin
        image_blue[0] <= 8'b00100000;
        image_blue[1] <= 8'b00110000;
        image_red[0] <= 8'b00010000;
        image_red[1] <= 8'b00000000;
        image_red[2][4] <= 0;
        secondFloor <= 0;
        elePas <= 1;
        end
        
        
    end 
  else if((firstFloor > 0 ) && (firstFloor <4) && (thirdFloor == 0) && (secondFloor == 0) && (elePas == 0) && ( image_blue[0][2] == 1)&& (counter == ((49_999_999) * 4)))
      begin
          counter <= {29{1'b0}}; 
          goUp = 0;
          goDown = 1;
          //int0 <= 4'b1000;
          if(firstFloor == 3)
          begin
               image_blue[0] <= 8'b00000000;
               image_blue[1] <= 8'b00001000;
               image_red[0] <= 8'b00001100;
               image_red[1] <= 8'b00000100;
               image_red[2][2] <= 0;
               image_red[2][3] <= 0;
               image_red[3][2] <= 0;
               firstFloor <= 0;
               elePas <= 3;
          end
          else if(firstFloor == 2)
          begin
          image_blue[0] <= 8'b00000000;
          image_blue[1] <= 8'b00001100;
          image_red[0] <= 8'b00001100;
          image_red[1] <= 8'b00000000;
          image_red[2][2] <= 0;
          image_red[2][3] <= 0;
          firstFloor <= 0;
          elePas <= 2;
          end
          else if(firstFloor == 1)
          begin
          image_blue[0] <= 8'b00001000;
          image_blue[1] <= 8'b00001100;
          image_red[0] <= 8'b00000100;
          image_red[1] <= 8'b00000000;
          image_red[2][2] <= 0;
          firstFloor <=0;
          elePas <= 1;
          end
      end  
 
    
    
end // end of if counter
end// end of always

endmodule //top module end

module ClockDivider( input clk, output clk_out);
 
     logic [26:0] count = {27{1'b0}};
     logic clk_NoBuf;
     always@ (posedge clk) begin
     count <= count + 1;
     end
     assign clk_NoBuf = count[26];
     BUFG BUFG_inst (
      .I(clk_NoBuf), // 1-bit input: Clock input
      .O(clk_out) // 1-bit output: Clock output
     );
 endmodule
 
 module timer(input exe,input res,input clk_out,input  [3:0] goOrDown,output [3:0] digit1,output [3:0]digit2,output [3:0] digit3,output [3:0] direction);
 logic[3:0] in1 = 4'b0000;
 logic[3:0] in2 = 4'b0000;
 logic[3:0] in3= 4'b0000;
 logic[3:0] dir= 4'b1010;
 always @ ( posedge clk_out)
 begin 

 if(exe == 1)
 begin
     if(res == 1)
begin
 in1 <= 0;
 in2 <= 0;
 in3 <= 0;
end 
            if(in1 < 4'b1001)
                in1 <= in1 +1;
            else
                 begin
                 if( in2 <4'b1001)
                     begin
                        in2 <= in2+1;
                        in1 <= 0;
                     end
                 else
                     begin
                        in3<= in3 +1;
                        in2 <= 0;
                        in1 <= 0;
                     end
             end   
        
   if(goOrDown == 4'b1111)
    begin
        if( dir == 4'b1111)
             dir <= 4'b1010; 
        else
         dir <= dir + 1;
            
    end
    else if(goOrDown == 4'b0000)
    begin
        if(dir == 4'b1010)
            dir <= 4'b1111;
        else
            dir <= dir -1;
    end
    else if(goOrDown == 4'b1000)
        dir <= 4'b1010;
 
 end
 end
 assign digit1 = in1;
 assign digit2 = in2;
 assign digit3 = in3;
 assign direction = dir;
 endmodule  

