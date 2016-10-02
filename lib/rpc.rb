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
    resp = call payload
    check_for_errors resp, method_name: method_name, args: args
    resp = parse resp
    resp
  end

  include ResponseParsing

  def check_for_errors(resp, method_name:, args: [])
    # TODO: improve
    raise "ParseError: #{resp.inspect} - Method name: '#{method_name}' - Params: '#{args}'" if resp["error"]
    resp
  end

  include MethodLookup
end
