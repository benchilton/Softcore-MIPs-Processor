//Sign Extender
module signExtend (input logic [15:0] immediate, output logic [31:0] extended);

 assign extended = 32'(signed'(immediate));

endmodule
