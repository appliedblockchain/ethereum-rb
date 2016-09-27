module Utils
  def sym_keys(hash)
    hash.map { |key, val| [key.to_sym, val] }.to_h
  end
end
