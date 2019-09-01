class SymbolTable
  def initialize(symtable)
    @symboltable = symtable
  end

  def contain?(symbol)
  end

  def add_symtable(line, address)
    symboltable[line] = address
  end
  

  attr_reader :symboltable
end