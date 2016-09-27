module Ethereum::Connection::RPC
  # specific to ethereum

  def init_id
    @id = 0
  end

  def get_id
    @id += 1
    @id
  end

  def method(command, args: [])
    { jsonrpc: "2.0", method: command, params: args, id: get_id }.to_json
  end

  def call_method(method_name, args: [])
    method_name = lookup_method method_name
    payload = method method_name, args: args
    call payload
  end

  include MethodLookup
end
