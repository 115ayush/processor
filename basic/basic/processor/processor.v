`timescale 1ns / 1ps

module processor(
    input clk,
    output [7:0] instruction,
    output reg [7:0] instruction_register,
    output [3:0] x,
    output reg [3:0] answer,
	 output reg [3:0] A,
    output reg [6:0] y
);

assign x = 4'b0001;

reg [4:0] opcode;
reg slowclk = 0;
reg [71:0] count = 0;
reg [4:0] memory_adress_register;
reg [4:0] program_counter;
reg [2:0] memory_data_register;
reg [3:0] accumulator;
reg negative_flag;
reg overflow_flag;
reg check ;

/*memoryblock memoryblock (
    .clka(clk),
    .addra(memory_adress_register),
    .douta(instruction)
);*/

memo memo (
   .clka(clk),
    .addra(memory_adress_register),
    .douta(instruction)// output [7 : 0] douta
);

/*memorytest memorytest (
 .clka(clk),
    .addra(memory_adress_register),
    .douta(instruction)// output [7 : 0] douta // output [7 : 0] douta
);*/
/*
mmt mmt (
  .clka(clk),
    .addra(memory_adress_register),
    .douta(instruction)// outp // output [7 : 0] douta
);
*/
initial begin
    memory_adress_register <= 5'b00000;
    program_counter <= 0;
    opcode <= 0;
    negative_flag <= 0;
    overflow_flag <= 0;
	 check<=0;
end

always @(posedge clk) begin
    count <= count + 1;
    if (count == 10000000) begin
        slowclk <= ~slowclk;
        count <= 0;
    end
end

always @(posedge slowclk) begin
    instruction_register <= instruction;
    opcode <= instruction_register[7:3];
    memory_data_register <= instruction_register[2:0];

    case (opcode)
        5'b00010: begin   //LOAD
            accumulator <= memory_data_register;
            A <= accumulator;
				answer <= accumulator;
        end
        5'b00100: begin  //ADD
            accumulator <= accumulator + memory_data_register;
            if (accumulator > 15) begin
                overflow_flag <= 1;
					  answer <= accumulator;
             //   answer <= 0;
            end
            else begin
                answer <= accumulator;
                overflow_flag <= 0;
            end
        end
        5'b01000: begin  //SUBTRACT
            if (accumulator < memory_data_register) begin
                negative_flag <= 1;
               // answer <= 0;
            end
            else begin
                accumulator <= accumulator - memory_data_register;
                answer <= accumulator;
                negative_flag <= 0;
            end
        end
        5'b10000: begin
		        if(negative_flag == 1'b0 )
				  begin
		      //  program_counter <= program_counter+1;
				  check<=1'b1;
				  end
		        end 
        default: answer <= 0;
    endcase
       
    program_counter <= program_counter + 1;
	 
    memory_adress_register <= program_counter;
///	 check<=1'b0;

    if (program_counter >= 14) begin // jump if memory adress reaches 14
       program_counter<=0;
    end
end

always @* begin
    case (accumulator)
       4'b0000: y = 7'b0000001; // "0"
        4'b0001: y = 7'b1001111; // "1"
        4'b0010: y = 7'b0010010; // "2"
        4'b0011: y = 7'b0000110; // "3"
        4'b0100: y = 7'b1001100; // "4"
        4'b0101: y = 7'b0100100; // "5"
        4'b0110: y = 7'b0100000; // "6"
        4'b0111: y = 7'b0001111; // "7"
        4'b1000: y = 7'b0000000; // "8"
        4'b1001: y = 7'b0000100; // "9"
        4'b1010: y = 7'b0001000; // "A"
        4'b1011: y = 7'b1100000; // "b"
        4'b1100: y = 7'b0110001; // "C"
        4'b1101: y = 7'b1000010; // "d"
        4'b1110: y = 7'b0110000; // "E"
		  /*
		 5'b00000: y = 7'b0000001; // "0"
        5'b00001: y = 7'b1001111; // "1"
        5'b00010: y = 7'b0010010; // "2"
        5'b0011: y = 7'b0000110; // "3"
        5'b00100: y = 7'b1001100; // "4"
        5'b00101: y = 7'b0100100; // "5"
        5'b00110: y = 7'b0100000; // "6"
        5'b00111: y = 7'b0001111; // "7"
        5'b01000: y = 7'b0000000; // "8"
        5'b01001: y = 7'b0000100; // "9"
        5'b01010: y = 7'b0001000; // "A"
        5'b01011: y = 7'b1100000; // "b"
        5'b01100: y = 7'b0110001; // "C"
        5'b01101: y = 7'b1000010; // "d"
        5'b01110: y = 7'b0110000; // "E"
		  5'b10000: y = 7'b0110000;
		
		  3'b000 :y = 7'b0000001;
		  3'b001 :y = 7'b1001111;
		  3'b010 : y = 7'b0010010;
		  3'b011 :y = 7'b0000110;
		  3'b100 :y = 7'b1001100;
		  3'b101 :y = 7'b0100100;
		  3'b110 :y = 7'b0100000;
		  3'b111 : y = 7'b0001111;*/
        default: y = 7'b0111000; // "F"
    endcase
end

endmodule
