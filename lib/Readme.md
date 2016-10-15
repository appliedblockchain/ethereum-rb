# BApp2

Blockchain App framework - version2 #ruby-lang

Files contained in `bapp2/lib`:

    actions_extra.rb # <- all the extra actions (get block height, estimate transaction cost, etc..)
    actions_main.rb # <- this file contains the main actions of bapp2, the main interfaice to your ruby classes - the get-data and transact/execute methods - see #ActionsMain section
    connection.rb # <- connection includes the two RPC connection implementations, HTTP and IPC
    crypto.rb # <- sha3 TODO
    formatting.rb # <- contains transform_params and transform_outputs methods that deal with the formatting of intputs and outputs
    interface.rb # <- loads the contract code interface (contracts/application interface - ABI)
    method_lookup.rb # <- mapping between internal methods to ethereum methods
    response_parsing.rb # <- json TODO
    rpc_calls.rb # <- method calls (goes trough method name lookup first), exposes call_method for making RPC calls  
    tx_handlers.rb # <- strategies to wait for confirmation (current: wait_block)
    types.rb # <- from_ascii / to_ascii value formatting
    utils.rb # <- TODO
    vendor
      formatter.rb # #bapp2 's only dependency from DigixGlobal/ethereum-ruby on github - used for data formatting - changes: - added support of type "bytes" (see types.rb)
    version.rb

------


### #ActionsMain - actions_main.rb

- Ethereum calls will be done synchronously, but your app will ran multiple processes (because handling processes at OS level #useBash).

- ActionsMain contains 2 methods

- get

  consisted of one call

- set
