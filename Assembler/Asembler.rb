require_relative 'SymTable.rb'
require_relative 'Parse.rb' 
SYMTABLE = {
  'SP'   => 0,
  'LCL'  => 1,
  'ARG'  => 2,
  'THIS' => 3,
  'THAT' => 4,

  'R0' => 0,
  'R1' => 1,
  'R2' => 2,
  'R3' => 3,
  'R4' => 4,
  'R5' => 5,
  'R6' => 6,
  'R7' => 7,
  'R8' => 8,
  'R9' => 9,
  'R10' => 10,
  'R11' => 11,
  'R12' => 12,
  'R13' => 13,
  'R14' => 14,
  'R15' => 15,

  'SCREEN' => 0x4000,
  'KBD'    => 0x6000
};
def main (filename)
	asm = open(filename)
	puts asm

	symtable = SymbolTable.new(SYMTABLE)
	parser = Parser.new(asm)
	address = 16;
	parser.parse(symtable, address)
	filename = File.basename(filename.split('/').last, '.asm')
	file =File.open( "../Hack_Test/"+filename+".hack", 'w')
	file.puts(parser.gen_code)
end

Dir["../ASM/*"].each{|file| main(file)}









#puts !!(21.to_s =~ /\A[-+]?\d*\.?\d+\z/)
# route = './rect/RectL'
# # route = './pong/PongL'
# # route = './max/MaxL'
# file =File.open( "test.hack", 'w')
# file.puts("test")
# main(route + ".asm")
# Dir["../ASM/*"].each{|file| puts File.basename(file.split('/').last, '.asm')}



