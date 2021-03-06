//size general purpose registers, reading from address 0 will always return 0
//structured as:
/* Taken from: http://www.cs.uwm.edu/classes/cs315/Bacon/Lecture/HTML/ch05s03.html
Register Number		Conventional Name	Usage
$0			$zero			Hard-wired to 0
$1			$at			Reserved for pseudo-instructions
$2 - $3			$v0, $v1		Return values from functions
$4 - $7			$a0 - $a3		Arguments to functions - not preserved by subprograms
$8 - $15		$t0 - $t7		Temporary data, not preserved by subprograms
$16 - $23		$s0 - $s7		Saved registers, preserved by subprograms
$24 - $25		$t8 - $t9		More temporary registers, not preserved by subprograms
$26 - $27		$k0 - $k1		Reserved for kernel. Do not use.
$28			$gp			Global Area Pointer (base of global data segment)
$29			$sp			Stack Pointer
$30			$fp			Frame Pointer
$31			$ra			Return Address
$f0 - $f3		-			Floating point return values
$f4 - $f10		-			Temporary registers, not preserved by subprograms
$f12 - $f14		-			First two arguments to subprograms, not preserved by subprograms
$f16 - $f18		-			More temporary registers, not preserved by subprograms
$f20 - $f31		-			Saved registers, preserved by subprograms
*/
module register #(parameter size = 32, length = $clog2(size), dataSize = 32)
	(input logic clk, writeEnable, saveJump, input logic [length-1:0] rAddress1, rAddress2, wAddress1, pcCount, 
	input logic [size-1:0] wdata, output logic [size-1:0] rdata1, rdata2);

logic [size-1:0] registers [dataSize-1:0];

always_ff @(posedge clk)
begin
	if(writeEnable)
		registers[wAddress1] <= wdata;
	if(saveJump)
		registers[5'b11111] <= pcCount;
		
end

always_comb
begin
	if(rAddress1 == '0)
		rdata1 = '0;
	else
		rdata1 = registers[rAddress1];
	if(rAddress2 == '0)
		rdata2 = '0;
	else
		rdata2 = registers[rAddress2];
end

endmodule