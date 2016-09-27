
DEBUG = true
# DEBUG = false

# DEBUG_CONN = true
DEBUG_CONN = false


BLOCK_TIMEOUT = 3 # seconds - tx confirmation timeout (wait_for_block)


module Ethereum

  include TxHandlers
  include ResponseParsing

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

end



# command = "eth_coinbase"
# args = []
# payload = { jsonrpc: "2.0", method: command, params: args, id: get_id }
# resp = call payload.to_json
# p resp

# ---

include Ethereum

main

# ---

# payload = { jsonrpc: "2.0", method: "eth_coinbase", params: [], id: 1 }.to_json
# call_ipc payload
