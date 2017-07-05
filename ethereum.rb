require_relative 'env'

DEBUG = false
# DEBUG = true

DEBUG_CONN = false
# DEBUG_CONN = true


module Ethereum
  class Eth

    attr_reader :interface

    def initialize
      @interface = load_interface

      @conn = if ENV["IPC"] == "1"
        Connection::IPC.new
      else
        Connection::HTTP.new
      end
    end

    def start(&block)
      if block_given?
        @conn.start do
          init
          block.call self
        end
      else
        @conn.start
        init
      end
    end

    alias :start! :start

    def init
      @coinbase = coinbase
      puts "Coinbase: #{@coinbase}"
      puts "Balance: #{balance}"
      puts "Block: #{block_get}"
      puts "Contracts: #{@interface.map{ |contr, interf| "#{contr}:#{interf[:address] || "<no_address>"}" }.join " - "}"
      puts "\n"
    end
  end

  # alias :RPC :Eth
  RPC = Eth
end

DEMO = ENV["DEMO_MODE"] || false

# demo usage

if DEMO
  ETH = Ethereum::Eth.new

  ETH.start do |eth|
    val = eth.get contract: :op_return, method: :data, params: []
    puts "Finished - got: #{val}"
  end

  # console
  #
  # irb -r ./ethereum.rb
  # e = Ethereum::Eth.new; (e.methods - Object.methods).sort
end

puts "status:OK" unless [nil, ''].include? ENV["CHECK"]
