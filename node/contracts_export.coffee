env = require './env'
_   = require 'underscore'
fs  = require 'fs'

c = console

contracts = env.contracts

for ctr in contracts
  delete ctr.instance
  delete ctr.compiled
  ctr

# c.log contracts

contracts_path = "#{process.cwd()}/contracts"
babi_path = "#{contracts_path}/contracts_babi.json"
c.log "out:", babi_path
fs.writeFileSync babi_path, JSON.stringify contracts

process.exit 0 # bye!
