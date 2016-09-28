# BApp2

Blockchain App framework - version2 #ruby-lang

Files contained in `bapp2/lib`:

    actions_extra.rb
    actions_main.rb # <- this file contains the main actions of bapp2, the main interfaice to your ruby classes - see #ActionsMain section
    connection.rb
    crypto.rb
    formatting.rb
    interface.rb
    method_lookup.rb
    parsing.rb
    response_parsing.rb
    rpc_calls.rb
    rpc.rb
    tx_handlers.rb
    types.rb
    utils.rb
    vendor
      formatter.rb # #bapp2 's only dependency from DigixGlobal/ethereum-ruby on github - used for fromAscii - toAscii (see types.rb)
    version.rb

------


### #ActionsMain - actions_main.rb

- Ethereum calls will be done synchronously, but your app will ran multiple processes (because handling processes at OS level #useBash).

- ActionsMain contains 2 methods

- get

  consisted of one call 

- set
