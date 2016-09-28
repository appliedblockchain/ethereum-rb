module Formatting

  private

  # transform input params (get/set)
  #
  def transform_params(params, inputs:)
    params = params.map{ |param| param }
    # params = params.map{ |param| param.to_s } FIXME
    params_tuple = inputs.map{ |inp| inp["type"] }.zip params
    params = []
    params_tuple.each do |param|
      params << FRM.to_payload(param)
    end
    params
  end

  def transform_outputs(params, outputs:)
    params = params.gsub(/^0x/,'').scan /.{64}/
    params_tuple = outputs.map{ |out| out["type"] }.zip params
    params = []
    params_tuple.each do |param|
      params << FRM.from_payload(param)
    end
    params
  end

  # parse output types
  #
  def parse_types(resp, outputs:)
    if resp.is_a? Array
      values = resp
      values.map.with_index do |value, idx|
        output = outputs[idx]
        parse_type_read value, type: output["type"]
      end
    else
      output = outputs.first
      parse_type_read resp, type: output["type"]
    end
  end

end
