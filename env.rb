require 'socket'
require 'net/http'
require 'json'

require 'bundler'
Bundler.require :default

Oj.default_options = { mode: :compat }

path = File.expand_path "../", __FILE__
PATH     = path
APP_PATH = path

# ---------
# configs:

IPC_PATH = "#{ENV["HOME"]}/.parity/jsonrpc.ipc"

# RPC_HOST = "http://127.0.0.1"
RPC_HOST = "localhost"
RPC_PORT = "8545"


CONTRACTS_DIR = "#{path}/contracts"
CONFIG_DIR    = "#{path}/config"

# ---


# init main module
module Ethereum
end

require_relative './lib/vendor/formatter'
FRM = Ethereum::Formatter.new


# ---

require_relative 'lib/utils'
require_relative 'lib/types'
require_relative 'lib/crypto'
include Crypto
require_relative 'lib/parsing'
require_relative 'lib/tx_handlers'
require_relative 'lib/response_parsing'
require_relative 'lib/method_lookup' # find the implemented RPC methods here

require_relative 'lib/connection'
require_relative 'lib/interface'

# ---
