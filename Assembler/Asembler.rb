#C instuction => dest = comp; jump
DEST = {
	''  => '000',
	'M'   => '001',
	'D'   => '010',
	'MD'  => '011',
	'A'   => '100',
	'AM'  => '101',
	'AD'  => '110',
	'AMD' => '111'
}

JUMP = {
	''    => '000',
	'JGT' => '001',
	'JEQ' => '010',
	'JGE' => '011',
	'JLT' => '100',
	'JNE' => '101',
	'JLE' => '110',
	'JMP' => '111'
}

COMP = {
	'0'   => '0101010',
	'1'   => '0111111',
	'-1'  => '0111010',
	'D'   => '0001100',
	'A'   => '0110000',
	'!D'  => '0001101',
	'!A'  => '0110001',
	'-D'  => '0001111',
	'-A'  => '0110011',
	'D+1' => '0011111',
	'A+1' => '0110111',
	'D-1' => '0001110',
	'A-1' => '0110010',
	'A+D' => '0000010',
	'D+A' => '0000010',
	'D-A' => '0010011',
	'A-D' => '0000111',
	'D&A' => '0000000',
	'A&D' => '0000000',
	'D|A' => '0010101',
	'A|D' => '0010101',
	'M'   => '1110000',
	'!M'  => '1110001',
	'-M'  => '1110011',
	'M+1' => '1110111',
	'M-1' => '1110010',
	'D+M' => '1000010',
	'M+D' => '1000010',
	'D-M' => '1010011',
	'M-D' => '1000111',
	'D&M' => '1000000',
	'D|M' => '1010101',
	'M&D' => '1000000',
	'M|D' => '1010101',
}

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


A_COMMAND = Object.new
C_COMMAND = Object.new
L_COMMAND = Object.new
def main (filename)
	asm = open(filename)
	#chek if symbol is in symtable if not add it
	binary = parse(asm)
	puts binary
	binary
	# output_hack(binary)
end

#parse each line
def parse(asm)
	address = 16;
	gen_code = []
	parsed_asm = asm.map { |line| line.sub(%r{//.*$}, '').strip }.reject(&:empty?)
	parsed_asm.each{|line|
		unless line.empty?
			case command_type(line)
			when A_COMMAND
				line.slice! "@"
				memory = line
				if !!(line.to_s =~ /\A[-+]?\d*\.?\d+\z/)
					memory = line
				else
					if SYMTABLE[line].nil?
						add_symtable(line, address)
						address+=1
					end
					memory = SYMTABLE[line.strip]
				end
				puts memory
				gen_code.push('0%015b' % memory)
			when C_COMMAND
				gen_code.push('111'+COMP[comp(line)]+DEST[dest(line)]+JUMP[jump(line)])
			end
		end
	}
	gen_code
end

def command_type(current)
	if current.start_with?('@')
	  A_COMMAND
	elsif current.start_with?('(')
	  L_COMMAND
	else
	  C_COMMAND
	end
end


def add_symtable(line, address)
	SYMTABLE[line] = address
end

def dest(current)
	if current.include?('=')
	  current.split('=').first
	else
	  ''
	end
end

def comp(current)

	current
	  .split('=').last
	  .split(';').first
end

def jump(current)

	if current.include?(';')
	  current.split(';').last
	else
	  ''
	end
end

#puts !!(21.to_s =~ /\A[-+]?\d*\.?\d+\z/)
route = './rect/RectL'
# # route = './pong/PongL'
# # route = './max/MaxL'
# file =File.open( "Rect.hack", 'w')
# file.puts(main(route + ".asm"))
main(route + ".asm")