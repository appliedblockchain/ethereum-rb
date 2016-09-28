module Ethereum::Types

  private

  def to_ascii(value)
    Ethereum::Formatter.new.to_ascii value
  end

  def from_ascii(value)
    Ethereum::Formatter.new.from_ascii value
  end
  
end
