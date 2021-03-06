//input1 is rs
//input2 is rt or rd, rd if regdest == 1
module ALU #(parameter dataSize) (input logic [5:0] aluOP, input logic [dataSize-1:0] input1, input2,
				output logic [dataSize-1:0] result, result_up, output logic carry, zero, overflow);

logic [2*dataSize-1:0] product;//we need 64 bits for 32bit multiplication.

enum {NOP,AND,OR,NOR,XOR,ADD,SUB,MULT,DIV,SLT,SLL,SLA,SRL,SRA} operation;

always_comb
begin
	carry = 0;
	zero = 0;
	overflow = 0;
	result_up = 0;
	product = 0;
	unique case (aluOP)
	6'b111111:
	begin
		result = 0;
		operation = NOP;
	end
	6'b000000://AND
	begin
		result = input1 & input2;
		operation = AND;
	end
	6'b000001://OR
	begin
		result = input1 | input2;
		operation = OR;
	end
	6'b000010://Add
	begin
		result = input1 + input2;
		zero = (result) ? 0 : 1;//If result is zero then set zero flag
		operation = ADD;
	end
	6'b000011://Sub
	begin
		{carry,result} = {1'b0,input1} - {1'b0,input2};
		overflow = (carry) ? 0 : 1;//If carry is 1 then set overflow flag
		zero = (result) ? 0 : 1;//If result is zero then set zero flag
		operation = SUB;
	end
	6'b000100://slt
	begin
		result = (input1 < input2) ? 1 : 0;
		operation = SLT;
	end
	6'b000101://NOR
	begin
		result = ~(input2 | input2);// note ~| isnt supported by default
		operation = NOR;
	end
	6'b000110://Mult
	begin
		product = input1 * input2;
		zero = product ? 0 : 1;
		result_up = product[2*dataSize-1:dataSize];
		result = product[dataSize-1:0];
		operation = MULT;
	end
	6'b000111://Div
	begin
		product = input1 * input2;
		result_up = product[2*dataSize-1:dataSize];
		result = product[dataSize-1:0];
		operation = DIV;
	end
	6'b000111://XOR
	begin
		result = input1 ^ input2;
		operation = XOR;
	end
	6'b001000://Left Shift Logical
	begin
		result = input1 << input2[10:6];//input2 in this case is shamt
		operation = SRL;
	end
	6'b001001://Left Shift Arithmatic
	begin
		result = signed'(input1) <<< input2[10:6];
		operation = SLA;
	end
	6'b001010://Shift Right Logical
	begin
		result = input1 >> input2[10:6];
		operation = SRL;
	end
	6'b001011://Shift Right Arithmetic
	begin
		result = signed'(input1) >>> input2[10:6];
		operation = SRA;
	end
	endcase
end

endmodule