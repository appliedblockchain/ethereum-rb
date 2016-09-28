These specs require an ethereum instance running

I suggest a parity proof-of-authority testnet/devnet or instant validation (parity as well), otherwise if you're stuck with pow for integration testing well, use a low difficulty and a powerful machine :D #makeTestEasy #makeTestFast


Run the simple set of specs (baisc_spec.rb - basic integration specs) with this command:

    ./spec

report errors to francesco at appliedblockchain.com

---

Future:


These specs are made using rspec: <http://rspec.info/>  

setting up the specs:

    bundle

running the specs:

    rspec
