require 'socket'
require 'net/http'
require 'json'

require 'bundler'
Bundler.require :default

Oj.default_options = { mode: :compat }

path = File.expand_path "../", __FILE__
ETH_PATH = path

# ---------
# configs:

# ETH_LOG = false
ETH_LOG = true # enable logs for debugging purposes (development)


IPC_PATH = "#{ENV["HOME"]}/.parity/jsonrpc.ipc"

# RPC_HOST = "http://127.0.0.1"
RPC_HOST = "localhost"
RPC_PORT = "8545"


CONTRACTS_DIR = "#{path}/contracts"
CONFIG_DIR    = if defined? ETH_CONFIG_DIR
  ETH_CONFIG_DIR
else
  "#{path}/config"
end

# ---


# init main module
module Ethereum
end

require_relative './lib/vendor/formatter'
FRM = Ethereum::Formatter.new


# ---

require_relative 'lib/version'
require_relative 'lib/utils'
require_relative 'lib/types'
require_relative 'lib/crypto'
include Crypto
# require_relative 'lib/parsing' # not needed, using lib/vendor/formatter from digix, need to implement bytes
require_relative 'lib/formatting'
require_relative 'lib/rpc_calls'
require_relative 'lib/tx_handlers'
require_relative 'lib/actions_main'
require_relative 'lib/actions_extra'
require_relative 'lib/response_parsing'
require_relative 'lib/method_lookup' # find the implemented RPC methods here

require_relative 'lib/connection'
require_relative 'lib/interface'

# ---

module Ethereum
  class Eth
    include Types
    include Interface
    include TxHandlers
    include ResponseParsing
    # include Parsing
    include Formatting
    include RpcCalls
    include ActionsMain
    include ActionsExtra
    include Utils
  end
end
