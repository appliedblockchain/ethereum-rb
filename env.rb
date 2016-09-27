require 'socket'
require 'net/http'
require 'json'

require 'bundler'
Bundler.require :default

Oj.default_options = { mode: :compat }


# ---------
# configs:

IPC_PATH = "#{ENV["HOME"]}/.parity/jsonrpc.ipc"

# RPC_HOST = "http://127.0.0.1"
RPC_HOST = "localhost"
RPC_PORT = "8545"


# ---


# init main module
module Ethereum
end

require_relative './lib/vendor/formatter'
FRM = Ethereum::Formatter.new


# ---

require_relative 'lib/crypto'
include Crypto



require_relative 'lib/tx_handlers'
