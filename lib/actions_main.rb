module ActionsMain

  def get(contract:, method:, params: [])
    from = @coinbase
    contract = @interface[contract]
    contract_address = contract[:address]

    method_name = method
    method = contract[:methods].find{ |m| m["name"] == method_name.to_s }
    raise "Cannot contract method '#{method_name}' (contract: #{contract[:class_name]})" unless method
    method = sym_keys method
    sig = method[:methodId]
    # raise sig.inspect
    raise "Cannot find sha3 signature for method '#{method}'" unless sig

    params = transform_params params, inputs: method[:inputs]
    data = "#{sig}#{params.join}"

    # raise contract.inspect
    outputs = method[:outputs]

    puts "get #{contract[:class_name]}.#{method_name}(#{params.join ", "})"
    resp = read [{from: from, to: contract_address, data: data}]
    resp = parse resp
    puts "Resp (raw): #{resp}" if DEBUG

    resp = parse_types resp, outputs: outputs
    puts "Resp (types): #{resp}" if DEBUG
    # resp = FRM.from_payload(resp)
    resp = [resp] unless resp.is_a? Array
    resp = transform_outputs resp, outputs: method[:outputs]

    resp = if resp.size == 1
      resp.first
    else
      # TODO: extract in formatter
      # render_outputs
      resp_hash = {}
      method[:outputs].each_with_index do |out, idx|
        raise "TODO - maybe it works though".inspect
        raise out.inspect
        resp_hash[out["name"]] = resp[idx]
      end
      resp_hash
    end
    puts "Resp: #{resp.inspect}" if DEBUG
    resp
  end

  def set(contract:, method:, params: [])
    last_block = block_get
    transact contract: contract, method: method, params: params
    if wait_block last_block
      true
    else
      puts "retrying set..."
      set contract: contract, method: method, params: params
    end
  end


  private

  def transact(contract:, method:, params: [])
    from = @coinbase
    contract = @interface[contract]
    contract_address = contract[:address]

    method_name = method
    method = contract[:methods].find{ |m| m["name"] == method_name.to_s }
    raise "Cannot contract method '#{method_name}' (contract: #{contract[:class_name]})" unless method
    method = sym_keys method
    sig = method[:methodId]
    # raise sig.inspect
    raise "Cannot find sha3 signature for method '#{method}'" unless sig

    params_raw = params
    params = transform_params params, inputs: method[:inputs]
    data = "#{sig}#{params.join}"

    # gas = "0x8e52"
    gas = "0x100000"

    puts "set #{contract[:class_name]}.#{method_name}(#{params_raw.join ", "})"
    resp = write [{from: from, to: contract_address, data: data, gas: gas}]
    resp = parse resp

    resp
  end

end
