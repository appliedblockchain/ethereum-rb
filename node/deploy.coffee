fs  = require 'fs'
env = require './env'
c   = console
eth = env.eth

# TODO: do this in contractsLib and reuse code
saveContractAddress = (contract_name, instance_address) ->
  config_path = "#{process.cwd()}/../config"

  # c.log "paths > #{__dirname} - #{process.cwd()} - #{process.argv[1]} == #{require.main.filename} #{ }"
  contracts_json_path   = "#{config_path}/contracts.json"
  contracts_config      = fs.readFileSync contracts_json_path
  config                = JSON.parse contracts_config
  config[contract_name] = instance_address
  config_json           = JSON.stringify config, null, 2
  fs.writeFileSync contracts_json_path, config_json

displayErr = (label, err) ->
  c.error "Got error when '#{label}':"
  c.error "#{JSON.stringify err}\n"

renderDeployError = (res, err) ->
  displayErr "deploying contract", err
  if err.message == "Account does not exist or account balance too low"
    c.log "Coinbase address: '#{coinbase}'"
    eth.getBalance coinbase, (err, balance) ->
      c.log "Balance: #{balance} wei"

  message = "The deployment of the contract failed, this is the full error message: '#{err.message}'"
  c.error err.message
  throw err


deployContract = (coin_base, contract, res) ->
  c.log "Deploying contract: #{contract.name}"
  c.log "coinbase", coin_base
  coinbase = coin_base

  Contract = eth.contract contract.abi
  # c.log "Contract (class): #{Contract}"
  ctr = contract.compiled.contracts[contract.class_name]
  # c.log "contract: #{JSON.stringify ctr}"
  options =
    data: "0x#{ctr.bytecode}",
    from: coinbase,
    gas:  1e5      # 100_000
    # gas:  1e10   # 1_000_000_000
    # gas:  1e6    # 1_000_000
  # c.log "OPTIONS: #{JSON.stringify options}"


  Contract.new options, (err, contract_instance) ->
    instance = contract_instance
    c.log "#{contract.class_name}.new called"
    if err
      renderDeployError res, err
    else
      if instance.address
        c.log "  deployed!"
        c.log "  address: #{instance.address}\n"

        contract.address      = instance.address
        contract.deployed     = true

        saveContractAddress contract.name, instance.address

        # TODO: fixme - refresh the contract in contracts in memory
        #
        # contracts = _(contracts).reject (contr) ->
        #     contr.name == contract.name
        # contracts.push contract


        callback = res
        callback contract



module.exports =
  deployContract: deployContract
