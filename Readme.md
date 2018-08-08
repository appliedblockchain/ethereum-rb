### Ethereum-Ruby

RPC Client

### Setup


**Option 1: Reference it from the Gemfile**

    gem "ethereum", git: "https://GITHUB_TOKEN@github.com/appliedblockchain/ethereum.git"
    
when this will be open source (bytes bug fixed + maybe some basic tests + add more methods probably...), we can simply do:
    
    gem "ethereum", git: "https://github.com/appliedblockchain/ethereum.git"


**Option 2: Download it manually on a local directory** and use `path:`

Download:

    git clone git@github.com:appliedblockchain/ethereum
    git clone https://GITHUB_TOKEN@github.com/appliedblockchain/ethereum.git

Add to Gemfile

    gem "ethereum", path: File.expand_path("~/local_dir/ethereum")


### Usage

    // Specify the file name for your contract interface
    ETH = Ethereum::Eth.new "Cygnetise.json"
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


----


RPC Calls List: https://github.com/appliedblockchain/ethereum/blob/master/lib/rpc_calls.rb#L1

--- 

notes

Implemented methods (current status):

https://github.com/appliedblockchain/ethereum/blob/master/lib/method_lookup.rb#L7


LOC < 800
