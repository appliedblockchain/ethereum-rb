require_relative 'env'

DEBUG = true
# DEBUG = false

# DEBUG_CONN = true
DEBUG_CONN = false


module Ethereum
  class Eth

    def initialize
      @interface = load_interface
      @conn = Connection::IPC.new
    end

    def start(&block)
      # @conn = Connection::HTTP.new
      @conn.start do
        @coinbase = coinbase
        puts "Coinbase: #{@coinbase}"
        puts "Balance: #{balance}"
        puts "Block: #{block_get.hex}"
        puts "Contracts: #{@interface.map{ |contr, interf| "#{contr}:#{interf[:address]}" }.join " - "}"
        puts "\n"

        block.call self
        # 10.times do
        #   r = get contract: :op_return, method: :data, params: []
        #   set     contract: :op_return, method: :set,  params: [44]
        #
        #   r = get contract: :op_return, method: :data, params: []
        #   set     contract: :op_return, method: :set,  params: [45]
        # end
      end

      true
    end
  end

end

DEMO = false

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
