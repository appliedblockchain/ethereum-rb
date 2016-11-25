# TODO

- Add retries against parity returning errors "under stress" (even with the right parameters)

    /home/makevoid/apps/ethereum/lib/rpc.rb:31:in `check_for_errors'

example:

    ParseError: "{\"jsonrpc\":\"2.0\",\"error\":{\"code\":-32602,\"message\":\"Invalid params\",\"data\":null},\"id\":268}" - Method name: 'eth_coinbase' - Params: '[]'

---

- rm contracts.json and contracts_interface - already gitignored

- test suite with parity instant chain
