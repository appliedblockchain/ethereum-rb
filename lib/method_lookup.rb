module MethodLookup

  # a good reference to see which methods are already implemented

  # TODO: re-integrate with main code later

  def lookup_method(name)
    case name
    when "coinbase"
      "eth_coinbase"
    when "read"
      "eth_call"
    when "write"
      "eth_sendTransaction"
    when "cost"
      "eth_estimateGas"
    when "receipt"
      "eth_getTransactionReceipt"
    when "balance"
      "eth_getBalance"
    when "block"
      "eth_blockNumber"
    when "block_by_num"
      "eth_getBlockByNumber"
    else
      raise "NOT HANDLED".inspect
    end
  end

end
