fs         = require 'fs'
glob       = require "glob"
path       = require 'path'
_          = require 'underscore'
_string    = require 'underscore.string'
deasync    = require 'deasync'
classify   = _string.classify
capitalize = _string.capitalize
c          = console
# env        = require "./env"
# web3       = env.web3
# eth        = env.eth

stringify = (obj) ->
  JSON.stringify obj


DEBUG = true

# configs (paths)
#
contracts_path = "#{process.cwd()}/../contracts"
# contracts_path = "./contracts"
config_path        = "#{process.cwd()}/../config"

# "constants"
contracts_conf_path = "#{config_path}/contracts.json"

if DEBUG
  c.log "contracts_path:      #{contracts_path}"
  c.log "contracts_conf_path: #{contracts_conf_path}"

log = (name, contents) ->
  c.log "\n#{name}:"
  c.log contents
  c.log ''

# contract =
#   name:     null
#   source:   null
#   abi:      null
#   methods:  []
#   getters:  []
#   setters:  []

errCtrClassMismatch = (contract_class) ->
  "Contract class has to have the same name of the file (found class '#{contract_class}' defined with a different name from the '.sol' contract file name)"


USE_NPM_SOLC = true

solc = require 'solc' if USE_NPM_SOLC

module.exports = (web3) -> # TODO use env.web3 probably now is better
  eth = web3.eth

  compileSolidityDeasynced = (source, name) ->
    unless USE_NPM_SOLC
      # compileSolidityEth(source, name)
      #
      # compileSolidityEth = (source, name) ->
      #   ...
      result = null
      eth.compile.solidity source, (err, compiled) ->
        if err
          c.error "Error compiling solidity:"
          c.error err
          throw "ContractCompilationError - Aborting, check the source code of contract: #{name}"
        result = compiled
      while result == null
        deasync.runLoopOnce()
      result
    else # using npm solc (c++ solc code embedded in node package)
      # c.log "source (#{name}): #{source}" if DEBUG
      result = solc.compile source
      c.log "compiled: #{stringify(result)[0..100]} ..." if DEBUG
      # c.log "compiled: #{stringify result}"
      result

  # it doesn't work with solc, but we don't care as we're not using web3
  #
  # getInstance = (contract) ->
  #   Contract = eth.contract stringify contract.abi
  #   Contract.at contract.address

  parseContract = (contract) ->
    contract_class = capitalize classify(contract.name, true)
    compiled = compileSolidityDeasynced contract.source, contract_class
    contr = compiled.contracts[contract_class]
    c.log "#{contract_class} contract (compiled)"
    # throw errCtrClassMismatch(contract_class) unless contr
    # c.log "contract: #{stringify contr}"
    # c.log "keys: #{_.keys contr}"

    # Bytecode (used to deploy the contract)
    bytecode = contr.bytecode

    # ABI (used to call the contract)
    abi = if USE_NPM_SOLC
      JSON.parse contr.interface
    else
      contr.info.abiDefinition

    if USE_NPM_SOLC
      function_hashes = contr.functionHashes
      gas_estimates   = contr.gasEstimates

    # c.log "ABI: #{stringify abi}" if DEBUG

    abi = _(abi)
    methods = []
    getters = []
    setters = []

    abi_methods = abi.select (token) ->
      token.type == "function"
    abi_methods.map (abi_method) ->
      # console.log "name: #{abi_method.name}, constant: #{abi_method.constant}, inputs: #{stringify abi_method.inputs}, outputs: #{stringify abi_method.outputs}" if abi_method.name == "get" # <<< debug
      isSetter = abi_method.inputs.length > 0 && !abi_method.constant

      type = if isSetter then "setter" else "getter"
      inputTypes = _(abi_method.inputs).map (inp) -> inp.type
      methodId = web3.sha3("#{abi_method.name}(#{inputTypes.join(',')})")[0..9]

      method =
        name:     abi_method.name
        kind:     type
        inputs:   abi_method.inputs
        outputs:  abi_method.outputs
        methodId: methodId

      methods.push method
      if method.kind == "getter"
        getters.push method
      else
        setters.push method

    contract = _(contract).extend
      class_name: contract_class
      abi:        abi.value()
      compiled:   compiled
      methods:    methods
      getters:    getters
      setters:    setters
    # NOT USED, YAY!
    # contract.instance = getInstance contract
    contract

  readConfigs = ->
    contracts_config = fs.readFileSync contracts_conf_path
    JSON.parse contracts_config

  deleteAddressFromConf = (contract_name, callback) ->
    conf = readConfigs()
    delete conf[contract_name]
    conf = stringify conf, null, 2
    fs.writeFileSync contracts_conf_path, conf
    callback()

  readContracts = ->
    contracts = []
    contract_files   = glob.sync "#{contracts_path}/*.sol"
    config = readConfigs()

    log "contracts.json", config

    contract_files = _(contract_files).map (contract_path) ->
      name     = path.basename contract_path, ".sol"
      source   = fs.readFileSync contract_path
      address  = config[name]
      deployed = address?

      contract =
        name:     name
        path:     contract_path
        source:   source.toString()
        deployed: deployed
        address:  address

      contracts.push parseContract contract

    contracts


  # exports
  #
  readContracts:         readContracts
  deleteAddressFromConf: deleteAddressFromConf
