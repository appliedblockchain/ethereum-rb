# require 'pp'

module Ethereum
  module Interface
    # ABI

    include Utils

    def load_interface
      interface = "#{CONFIG_DIR}/contracts/contracts_interface.json"
      interface = File.read interface
      interface = JSON.parse interface
      parse_interface interface
    end

    def parse_interface(interface)
      contracts = interface
      interface = {}
      for contract in contracts
        contract = sym_keys contract
        contract[:name] = contract[:name].to_sym
        interface[contract[:name]] = contract
      end
      interface
    end
  end

  ABI = Interface
end
