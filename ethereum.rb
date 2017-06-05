require_relative 'env'

# loggers

DEBUG = false
# DEBUG = true

DEBUG_CONN = false
# DEBUG_CONN = true


# main module

module Ethereum


  # main class - RPC API

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
      puts "Contracts: #{@interface.map{ |contr, interf| "#{contr}:#{interf[:address]}" }.join " - "}"
      puts "\n"
    end
  end

  # alias :RPC :Eth
  RPC = Eth

end

# Ethereum module ends

# Usage Doc

# basic usage (simplest api - scripting level)
#
# require 'ethereum'
# include Ethereum
#
# # ---
#
# ETH.get # call
# ETH.set # sendTransaction

# ---

# TODO: to be continued...


# ---

# ETH

# ---

# Ethereum::ETH / Ethereum::RPC - ruby implementation of web3 - rpc js

# usage run  in the console
#
# irb -r ./ethereum.rb
# e = Ethereum::Eth.new; (e.methods - Object.methods).sort




# demo mode

DEMO = ENV["DEMO_MODE"] || false
require_relative 'lib/misc/demo_mode.rb' if DEMO

puts "status: OK" unless [nil, ''].include? ENV["CHECK"]
