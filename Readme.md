### Ethereum-Ruby

#### Ruby Ethereum RPC Client 

**PROJECT STATUS:** active but low maintainance

**FORK STATUS:** green - usable for prod

**FORKS present:** 0

We will probably support (test/develop) on your fork if you intend one and maintaini it.

### Missing from this fork

- documentation
-- general
-- threading model / locking / handling parallel connection
-- add ws via eventmachine and em http

(ruby toolkit in general for ethereum should be revaluated)



### Setup


**Reference it from the Gemfile**

    gem "ethereum", git: "https://github.com/appliedblockchain/ethereum.git"


### Usage

    // Specify the file name for your contract interface
    ETH = Ethereum::Eth.new "contract_interface.json"
    ETH.init
    
    ETH.coinbase #=> "0x1234567..."


## RPC Calls

TODO: document them all

#### ETH.coinbase

Returns the node's coinbase:

    ETH.coinbase #=>  "0x1234567..."
    
equivalent of getCoinbase() in web3

#### ETH.block(block_hash)

Returns the block infos (block id, hash, transaction_ids...)

    ETH.block "0x123456..." #=> {
    #  foo: "TODO: block infos",
    # }
    

equivalent of getBlock() in web3

#### ETH.block_by_num(block_num)

    ETH.block_by_num 1 #=> "0x12345..." # hash of the genesis block

#### ETH.transaction(tx_hash)

    ETH.block "0x123456..." #=> {
    #  foo: "TODO: transaction infos",
    # }

---

## Higher level api:


#### ETH.read(args=[])

Calls a contract (getter) - without modifying the state


    ETH.read "key" #=> "value" # (from SimpleStorage contract)
    

equivalent of `call()` in web3


#### ETH.write(args=[])

Calls a contract (setter) - pays the gas fee to change the local contract storage / global ethereum state

    ETH.write "key", "foobar" #=> true / tx_receipt # (save to SimpleStorage contract - TODO: recheck response, probably we want true in our configuration rather than the tx_receipt which we we don't generally use, 'cause we poll parity)
    
    
equivalent of `sendTransaction()` in web3


---

TODO: bump to v1
TODO: release the ruby gem to rubygems

---

Enjoy,
The Applied Blockchain Team
