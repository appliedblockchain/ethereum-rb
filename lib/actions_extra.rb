module ActionsExtra

  def block_get
    # puts "."
    res = block
    # puts "Block: #{res}"# if DEBUG
    "#{res}".hex
  end

  #
  # # not used yet
  #
  # # TODO useful for public chain: estimate gas cost
  # # TODO other option - get this estimate from solidity (compilation time)
  #
  # def cost
  #   from = @coinbase
  #   contract = @interface[contract]
  #   contract_address = contract[:address]
  #
  #   raise "TODO".inspect
  #
  #   resp = cost_gas [{from: from, to: contract_address, data: data}]
  #   raise resp.inspect
  #   resp
  # end
  #
  #
  # # TODO: receipt - not important
end
