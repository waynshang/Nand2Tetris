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
class Parser 
	A_COMMAND = Object.new
	C_COMMAND = Object.new
	L_COMMAND = Object.new

	def initialize(input)
		@lines = striped(input)
	end

	def striped(asm)
		asm.map { |line| line.sub(%r{//.*$}, '').strip }.reject(&:empty?)
	end

	def parse(symtable, address)
		# first 16 address have been used by default
		@gen_code = []
		# neglect white space and 
		lines.each{|line|
			@current = line
			unless current.empty?
				case command_type
				when A_COMMAND
					current.slice! "@"
					memory = current

					if !(current.to_s =~ /\D/)
						memory = current
					else
						if symtable.symboltable[current.strip].nil?
							symtable.add_symtable(current.strip, address)
							address+=1
						end
						memory = symtable.symboltable[current.strip]
					end
					gen_code.push('0%015b' % memory)
				when C_COMMAND
					gen_code.push('111'+COMP[comp]+DEST[dest]+JUMP[jump])
				end
			end
		}
		gen_code
	end


	def command_type
		if current.start_with?('@')
		  A_COMMAND
		elsif current.start_with?('(')
		  L_COMMAND
		else
		  C_COMMAND
		end
	end

	def dest
		if current.include?('=')
		  current.split('=').first
		else
		  ''
		end
	end

	def comp

		current
		  .split('=').last
		  .split(';').first
	end

	def jump
		if current.include?(';')
		  current.split(';').last
		else
		  ''
		end
	end
	private :striped, :command_type, :dest, :comp, :jump
	attr_reader :lines, :gen_code, :current
end

