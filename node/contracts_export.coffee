env = require './env'
_   = require 'underscore'
fs  = require 'fs'

c = console

contracts = env.contracts

for ctr in contracts
  delete ctr.instance
  delete ctr.compiled
  ctr



# c.log "\nContracts:"
# c.log "#{JSON.stringify contracts}\n"

config_path = "#{process.cwd()}/../config"
interface_path = "#{config_path}/contracts_interface.json"
c.log "out:", interface_path
fs.writeFileSync interface_path, JSON.stringify contracts

process.exit 0 # bye!
