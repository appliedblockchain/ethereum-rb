c = console
Web3 = require 'web3'
contractsLib = require './contracts_lib'
deasync = require 'deasync'

getCoinbase = ->
  res = null
  eth.getCoinbase (err, coinbase) ->
    res = coinbase
  while res == null
    deasync.runLoopOnce()
  res

# requires geth
#
# configs

c.log "RPC: #{process.env.RPC}"

if process.env.RPC == "1"
  c.log "Using RPC instead of IPC"
  geth_host = "http://127.0.0.1:8545" # TODO: load config and/or override using env vars
  provider = new Web3.providers.HttpProvider geth_host
else # IPC is the default method
  parity_ipc  = "#{process.env.HOME}/.parity/jsonrpc.ipc" # parity
  geth_ipc = parity_ipc
  # geth_ipc  = "#{process.env.HOME}/blockchain_data/geth.ipc" # geth dev
  # geth_ipc  = "#{process.env.HOME}/.ethereum/geth.ipc" # public chain
  #
  provider = new Web3.providers.IpcProvider  geth_ipc, require('net')

web3     = new Web3 provider
eth      = web3.eth

# if !web3.isConnected()
#   c.log "Ethereum (geth) is not connected - host: '#{geth_host}'"
#   c.log "exiting..."
#   process.exit 1
# #

contracts = contractsLib(web3).readContracts()


module.exports =
  web3:        web3
  eth:         eth
  contracts:   contracts
  getCoinbase: getCoinbase
