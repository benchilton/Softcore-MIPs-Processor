//Asynchronous module that conrols branches and Jumps.
//Also updates the PC counter every cycle.
module branchControl (input logic branch, jump, zero, Return, input logic [4:0] PC_Count, input logic [31:0] immediate, input1,
			output logic [4:0] newPC_Count);

logic pcsrc;
logic [4:0] address;
assign pcsrc = ((branch & zero) || jump) ? 1 : 0;//if we jump or the branch condition is met
assign address = (Return) ? input1 : immediate[4:0];

always_comb
begin
	if(pcsrc)
	begin
		if(jump)
			newPC_Count = address;
		else
			newPC_Count = PC_Count + address;
	end
	else
	begin
		newPC_Count = PC_Count + 1;
	end
end

endmodule
