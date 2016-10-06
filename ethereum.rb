require_relative 'env'

DEBUG = true
# DEBUG = false

# DEBUG_CONN = true
DEBUG_CONN = false


module Ethereum
  class Eth

    attr_reader :interface

    def initialize
      @interface = load_interface
      @conn = Connection::IPC.new
      # @conn = Connection::HTTP.new
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
      puts "Contracts: #{@interface.map{ |contr, interf| "#{contr}:#{interf[:address]}" }.join " - "}"
      puts "\n"
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

puts "status:OK" unless [nil, ''].include? ENV["CHECK"]
