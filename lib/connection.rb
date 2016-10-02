module Ethereum::Connection; end

require_relative 'rpc'

module Ethereum::Connection

  class IPC
    include RPC

    def initialize
      init_id
    end

    def start(&block)
      check_ipc_file!
      @socket = UNIXSocket.new IPC_PATH
      if block_given?
        block.call self
        @socket.close
      end
      @socket
    end

    def call(payload)
      # puts "Payload: #{payload}"
      @socket.puts payload
      # msg =  @socket.recv 1000000
      msg =  @socket.recv 10000000
      # msg += @socket.recv 10000000
      msg
    end

    def close
      @socket.close
    end

    private

    def check_ipc_file!
      raise "IPC file not found at path '#{IPC_PATH}' - Make sure parity/geth is running? ('cd parity; ./run')" unless  File.exists? IPC_PATH
    end
  end

  class HTTP # simplifies the Net::HTTP api a bit
    include RPC

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
      # puts "payload: #{payload}"
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

end
