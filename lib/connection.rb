module Ethereum::Connection
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

class ConnectionIPC
  include EthereumConnection

  def initialize
    init_id
  end

  def start(&block)
    @socket = UNIXSocket.new IPC_PATH
    block.call self
    @socket.close
  end

  def call(payload)
    # puts "Payload: #{payload}"
    @socket.puts payload
    # msg =  @socket.recv 1000000
    msg =  @socket.recv 10000000
    # msg += @socket.recv 10000000
    msg
  end
end

class ConnectionRPC # simplifies the Net::HTTP api a bit
  include EthereumConnection

  def initialize
    init_id
    url = "http://#{RPC_HOST}:#{RPC_PORT}"
    @uri = URI url
    header = {'Content-Type' => 'application/json'}
    @req = Net::HTTP::Post.new @uri, header
  end

  def start(&block)
    Net::HTTP.start(@uri.host, @uri.port) do |http|
      @http = http
      block.call self
    end
  end

  def call(payload)
    @req.body = payload
    resp = @http.request @req
    case resp
    when Net::HTTPSuccess
      resp.body
    else
      resp.error!
    end
  end

end
