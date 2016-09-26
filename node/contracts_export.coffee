env = require './env'
_   = require 'underscore'
fs  = require 'fs'

c = console

contracts = env.contracts

for ctr in contracts
  delete ctr.instance
  delete ctr.compiled
  ctr



c.log "\nContracts:"
c.log "#{JSON.stringify contracts}\n"

config_path = "#{process.cwd()}/../config"
babi_path = "#{config_path}/contracts_babi.json"
c.log "out:", babi_path
fs.writeFileSync babi_path, JSON.stringify contracts

process.exit 0 # bye!
