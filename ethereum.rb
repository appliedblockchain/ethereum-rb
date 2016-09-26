require 'socket'
require 'net/http'
require 'json'
require 'oj'

Oj.default_options = { mode: :compat }

DEBUG = true
# DEBUG = false

# DEBUG_CONN = true
DEBUG_CONN = false

IPC_PATH = "#{ENV["HOME"]}/.parity/jsonrpc.ipc"

# RPC_HOST = "http://127.0.0.1"
RPC_HOST = "localhost"
RPC_PORT = "8545"

require_relative './formatter'
FRM = Ethereum::Formatter.new

BLOCK_TIMEOUT = 3 # seconds - tx confirmation timeout (wait_for_block)


def parse(resp)
  resp = JSON.parse resp
  resp["result"]
end

def costz
  from = "0x433a8524aa6180f19f3d81f0a66454c0c5e644e2"
  contract_address = "0xbaea7ac25443d20a45c5db3e322ef572bc34b57e"
  method_sig = "update(uint256,bytes32,bytes32)"

  data = "0x9507d39a0000000000000000000000000000000000000000000000000000000000000001"


  resp = cost [{from: from, to: contract_address, data: data}]
  raise resp.inspect
  resp
end

def writez
  from = "0x433a8524aa6180f19f3d81f0a66454c0c5e644e2"
  contract_address = "0xbaea7ac25443d20a45c5db3e322ef572bc34b57e"
  method_sig = "update(uint256,bytes32,bytes32)"

  outputs = [
    {
      "name" => "_id",
      "type" => "uint256"
    },
    {
      "name" => "key",
      "type" => "bytes32"
    },
    {
      "name" => "value",
      "type" => "bytes32"
    }
  ]

  data = "0xb9dccd55000000000000000000000000000000000000000000000000000000000000000162000000000000000000000000000000000000000000000000000000000000006300000000000000000000000000000000000000000000000000000000000000"

  gas = "0x7e52"

  resp = write [{from: from, to: contract_address, data: data, gas: gas}]
  resp = parse resp

  resp
end


# TODO: delete
def writez2
  from = "0x433a8524aa6180f19f3d81f0a66454c0c5e644e2"
  contract_address = "0xbaea7ac25443d20a45c5db3e322ef572bc34b57e"
  method_sig = "update(uint256,bytes32,bytes32)"

  outputs = [
    {
      "name" => "_id",
      "type" => "uint256"
    },
    {
      "name" => "key",
      "type" => "bytes32"
    },
    {
      "name" => "value",
      "type" => "bytes32"
    }
  ]

  data = "0xb9dccd55000000000000000000000000000000000000000000000000000000000000000163000000000000000000000000000000000000000000000000000000000000006400000000000000000000000000000000000000000000000000000000000000"

  gas = "0x7e52"

  resp = write [{from: from, to: contract_address, data: data, gas: gas}]
  resp = parse resp

  resp
end

def receiptz(hash)
  receipt_hash = hash
  # receipt_hash = "0x3c367eda3be413b03faedc8113bf169f4c8cc61fde7f8aa2248616395adcf331"

  resp = receipt [receipt_hash]
  resp = parse resp

  resp
end

# eth_getTransactionReceipt

def readz
  from = "0x433a8524aa6180f19f3d81f0a66454c0c5e644e2"
  contract_address = "0xbaea7ac25443d20a45c5db3e322ef572bc34b57e"
  method_sig = "get(uint256)"

  params = ["0000000000000000000000000000000000000000000000000000000000000001"]

  outputs = [
    {
      "name" => "_id",
      "type" => "uint256"
    },
    {
      "name" => "key",
      "type" => "bytes32"
    },
    {
      "name" => "value",
      "type" => "bytes32"
    }
  ]

  sig = method_sig
  sig = sha_sig sig
  data = "0x#{sig}#{params.join}"

  resp = read [{from: from, to: contract_address, data: data}]
  # /entries_kv/get?id=1
  resp = parse resp

  puts "Resp (raw): #{resp}" unless DEBUG

  output = parse_get_resp resp, outputs: outputs
  puts "Resp: #{output}" unless DEBUG
  # raise output.inspect
  output
end

def parse_get_resp(resp, outputs:)
  output_types = []
  resp_split = resp.gsub(/^0x/,'').scan /.{64}/
  # puts "Resp (raw, split): #{resp_split}" unless DEBUG
  formatted_result = outputs.map { |out|  out.fetch "type" }.zip resp_split
  puts "Resp (raw, split): #{formatted_result}" unless DEBUG
  result = formatted_result.map { |res| FRM.from_payload res }

  output = {}
  outputs.each_with_index do |out, idx|
    output[out["name"]] = result[idx]
  end
  output
end

def sha_sig(content)
  Digest::SHA3.hexdigest(content, 256)[0..7]
end

def wait_for_block(last_block)
  time = Time.now
  loop do
    sleep 0.05 && return if last_block != block_get
    return if Time.now - time > BLOCK_TIMEOUT
    sleep 0.05
  end
end

# 2.18

def wait_for_change(value, &proc)
  time = Time.now
  loop do
    return if value != proc.call
    return if Time.now - time > BLOCK_TIMEOUT
    puts Time.now - time
    sleep 0.1
  end
end

def block_get
  res = parse block
  # puts "Block: #{res}"# if DEBUG
  res
end

def do_write
  resp = readz
  puts "EntriesKV.get(1): #{resp.inspect}"

  last_block = block_get
  resp = writez
  puts "EntriesKV.update(1, x, x): #{resp} (receipt)"

  resp = readz
  wait_for_change(resp) do
    readz
  end

  # wait_for_block last_block
  # puts "block found!"


  resp = readz
  puts "EntriesKV.get(1): #{resp.inspect}"

  puts "\n"
  # sleep 2

  resp = readz
  puts "EntriesKV.get(1): #{resp.inspect}"

  last_block = block_get
  resp = writez2
  puts "EntriesKV.update(1, y, y): #{resp} (receipt)"
  resp = readz
  wait_for_change(resp) do
    readz
  end
  puts "change ok"
  # wait_for_block last_block
  # puts "block found!"

  resp = readz
  puts "EntriesKV.get(1): #{resp.inspect}"

  puts "\n"
  # sleep 2
  # receipt_check receipt_hash
end

def receipt_check(receipt_hash)
  t = Time.now
  timeout = 1.5 # seconds
  while Time.now - t < timeout
    resp = receiptz receipt_hash
    puts "Receipt: #{resp}"
    break if resp
    sleep 0.1    # less spam - every 100ms
    # sleep 0.05 # 50ms
  end
  resp
end



def main
  # TODO: add pipelining

  @conn = ConnectionRPC.new
  # @conn = ConnectionIPC.new
  @conn.start do
    resp = coinbase
    puts "Coinbase: #{coinbase}"
    puts "Balance: #{balance}"
    puts "Block: #{block_get}\n\n"

    # 10000.times do
    # resp = readz
    # puts "EntriesKV.get(1): #{resp.inspect}"
    # end


    # sig = "get(uint256)"
    # sig = sha_sig sig

    20.times do
    resp = do_write
    end
    # unless resp
    #   resp = do_write
    # end
  end

  true


  # request:
  #
  # curl localhost:8545 -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0", "method":"eth_call", "params":[{"from": "0x433a8524aa6180f19f3d81f0a66454c0c5e644e2", "to": "0xbaea7ac25443d20a45c5db3e322ef572bc34b57e", "data": "0x9507d39a0000000000000000000000000000000000000000000000000000000000000001"}], "id":1}'
  #
  #
  # response:
  # {"jsonrpc":"2.0","result":"0x000000000000000000000000000000000000000000000000000000000000000161736400000000000000000000000000000000000000000000000000000000006173640000000000000000000000000000000000000000000000000000000000","id":1}
  #
end

# TODO: use define_method

def coinbase
  res = @conn.call_method "coinbase"
  parse res
end

def read(args=[])
  puts "ETH read: #{args.join ", "}" if DEBUG_CONN
  @conn.call_method "read", args: args
end

def write(args=[])
  puts "ETH write: #{args.join ", "}" if DEBUG_CONN
  p args.first[:data]
  @conn.call_method "write", args: args
end

def cost(args=[])
  @conn.call_method "cost", args: args
end

def receipt(args=[])
  @conn.call_method "receipt", args: args
end

def block(args=[])
  @conn.call_method "block", args: args
end

def balance(args=[])
  args = [coinbase] if args.empty?
  res = @conn.call_method "balance", args: args
  parse res
end


# def call(payload)
#   # TODO: add pipelining
#   uri = URI "http://#{RPC_HOST}:#{RPC_PORT}/"
#   http = Net::HTTP.new(uri.host, uri.port)
#   header = {'Content-Type' => 'application/json'}
#   req = Net::HTTP::Post.new uri, header
#   req.body = payload
#   resp = http.request req
#   return resp.body
# end

module EthereumConnection
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
    else
      raise "NOT HANDLED".inspect
    end
  end

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


# command = "eth_coinbase"
# args = []
# payload = { jsonrpc: "2.0", method: command, params: args, id: get_id }
# resp = call payload.to_json
# p resp

# ---

main

# ---

# payload = { jsonrpc: "2.0", method: "eth_coinbase", params: [], id: 1 }.to_json
# call_ipc payload
