env     = require './env'
deploy  = require './deploy'
_       = require 'underscore'
fs      = require 'fs'
deasync = require 'deasync'

c = console

eth       = env.eth
coinbase  = env.getCoinbase()
contracts = env.contracts

deployContract = (coinbase, contract) ->
  res = null
  deploy.deployContract coinbase, contract, (contractData) ->
    res = contractData
  while res == null
    deasync.runLoopOnce()
  res

for contract in contracts
  result = deployContract coinbase, contract, ->
    c.log "contract deployed: #{result.name}"
    c.log "getters: ", JSON.stringify result.getters
    c.log "setters: ", JSON.stringify result.setters
    c.log ""

c.log "done!"
process.exit 0
