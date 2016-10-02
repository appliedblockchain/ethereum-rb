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
    num = "0x#{num.to_s(16)}"
    res = @conn.call_method "block_by_num", args: [num, true]
    sym_keys res
  end

  # def cost_gas(args=[])
  #   @conn.call_method "cost", args: args
  # end
  #
  # def receipt(args=[])
  #   @conn.call_method "receipt", args: args
  # end

end
