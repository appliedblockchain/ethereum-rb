module MethodLookup

  # map ruby methods to ethereum RPC methods - the goal is to simplify the API a bit - a 1:1 mapping can be done as well (also by trimming all the prefixes like eth_ shh_ and underscoring the snake cased methods)

  # a good reference to see which methods are already implemented

  # TODO: re-integrate with another interface file later.. maybe

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
    when "transaction"
      "eth_getTransactionByHash"
    # watch
    when "filter_new"
      "eth_newPendingTransactionFilter"
    when "filter"
      "eth_getFilterChanges"
    when "filter_uninstall"
      "eth_uninstallFilter"
    else
      raise "NOT HANDLED".inspect
    end
  end

end
