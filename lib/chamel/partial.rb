class Partial
  attr_accessor :partial, :line_number, :node
  
  def initialize(partial,line_number)
    @partial = partial
    @line_number = line_number
  end
end