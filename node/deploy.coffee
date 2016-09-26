fs  = require 'fs'
env = require './env'
c   = console
eth = env.eth

# TODO: do this in contractsLib and reuse code
saveContractAddress = (contract_name, instance_address) ->
  config_path = "#{process.cwd()}/config"

  # c.log "paths > #{__dirname} - #{process.cwd()} - #{process.argv[1]} == #{require.main.filename} #{ }"
  contracts_json_path   = "#{config_path}/contracts.json"
  contracts_config      = fs.readFileSync contracts_json_path
  config                = JSON.parse contracts_config
  config[contract_name] = instance_address
  config_json           = JSON.stringify config, null, 2
  fs.writeFileSync contracts_json_path, config_json

displayErr = (label, err) ->
  console.error "Got error when '#{label}':"
  console.error "#{err}\n"

renderDeployError = (res, err) ->
  displayErr "deploying contract", err
  if err.message == "Account does not exist or account balance too low"
    c.log "Coinbase address: '#{coinbase}'"
    eth.getBalance coinbase, (err, balance) ->
      c.log "Balance: #{balance} wei"

  message = "The deployment of the contract failed, this is the full error message: '#{err.message}'"
  res.json
    error:       "contract_deployment_failed"
    message:     message
    eth_message: err.message


deployContract = (coin_base, contract, res) ->
  c.log "Deploying contract: #{contract.name}"
  c.log "coinbase", coin_base
  coinbase = coin_base

  Contract = eth.contract contract.abi

  options =
    data: contract.compiled[contract.class_name].code,
    from: coinbase,
    gas:  1e10      # 100_000_000
    # gas:      1e6 # 1_000_000

  Contract.new options, (err, contract_instance) ->
    instance = contract_instance

    if err
      renderDeployError res, err
    else
      if instance.address
        console.log "  address: #{instance.address}\n"
        console.log "done!"

        contract.address      = instance.address
        contract.deployed     = true

        saveContractAddress contract.name, instance.address

        # TODO: fixme - refresh the contract in contracts in memory
        #
        # contracts = _(contracts).reject (contr) ->
        #     contr.name == contract.name
        # contracts.push contract

        if res.json?
          res.json
            success: true
            address: contract.address
        else
          callback = res
          callback contract


module.exports =
  deployContract: deployContract
