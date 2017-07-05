module RpcCalls

  def read(args=[])
    puts "ETH read: #{args.join ", "}" if DEBUG_CONN
    @conn.call_method "read", args: args
  end

  def write(args=[])
    puts "ETH write: #{args.join ", "}" if DEBUG_CONN
    @conn.call_method "write", args: args
  end

  def block(args=[])
    @conn.call_method "block", args: args
  end

  def coinbase
    @conn.call_method "coinbase"
  end

  def balance(args=[])
    args = [coinbase] if args.empty?
    @conn.call_method "balance", args: args
  end

  def block_by_num(num)
    return nil if num < 1
    num = "0x#{num.to_s(16)}"
    res = @conn.call_method "block_by_num", args: [num, true]
    sym_keys res
  end

  def transaction(tx_hash)
    res = @conn.call_method "transaction", args: [tx_hash]
    sym_keys res
  end

  def filter_new(type: "pending")
    res = @conn.call_method "filter_new"#, args: [type]
    # sym_keys res
  end

  def filter(filter_id)
    res = @conn.call_method "filter", args: [filter_id]
    # sym_keys res
  end

  def filter_uninstall(filter_id)
    res = @conn.call_method "filter_uninstall", args: [filter_id]
    # sym_keys res
  end

  def gas
    @conn.call_method "gas"
  end

  def receipt(receipt_id)
    @conn.call_method "receipt", args: [receipt_id]
  end

end
