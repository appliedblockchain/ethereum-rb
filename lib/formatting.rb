module Formatting

  private

  # transform input params (set)
  #
  def transform_params(params, inputs:, set: false)
    raise "\n\nError: inputs should be or behave like an array - inputs.class: #{inputs.class}\n\n" unless inputs.is_a? Array

    input_types = inputs.map{ |inp| inp["type"] }

    params_tuples = input_types.zip params

    puts "transform_params - params_tuples: #{params_tuples.inspect}" if ETH_LOG
    # params = params.map{ |param| param }
    # # params = params.map{ |param| param.to_s } FIXME

    params = []
    params_tuples.each do |param|
      params << FRM.to_payload(param)
    end

    puts "transform_params - mid transformation:   #{params.inspect}" if ETH_LOG

    #
    # if input_types.include? "bytes"
    #   pars = []
    #   input_types.each_with_index do |type, idx|
    #     param = params[idx]
    #     param = if type == "bytes"
    #       if set
    #         param[128..-1]
    #       else
    #         p param
    #         puts "<<"
    #         "00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000001#{param}"
    #       end
    #     end
    #     pars << param
    #   end
    #
    #   params = [pars.join]
    # end
    # raise params.inspect  if input_types.include? "bytes"

    puts "transform_params - after transformation: #{params.inspect}" if ETH_LOG
    params
  end

  # transform output params (set)
  #
  def transform_outputs(params, outputs:)
    raise "\n\nError: outputs should be or behave like an array - outputs.class: #{outputs.class}\n\n" unless outputs.is_a? Array

    params.gsub! /^0x/, ''
    output_types = outputs.map{ |out| out["type"] }
    params_tuples = if output_types.include? "bytes"
      if output_types.size > 1
        raise "TODO - support multiple byte types".inspect
      else
        params = params.scan /.{64}/
        head, tail = params[0..1], params[2..-1].join
        # raise [head, tail].inspect
        output_types.zip [tail]
      end

      # params = params.scan /.{64}/
      # output_types.map do |type|
      #   head, tail = params[0], params[1..-1]
      #   if type == "bytes"
      #     params = tail[1..-1]
      #   else
      #     params = tail
      #   end
      # end
      # raise params.inspect
    else
      params = params.scan /.{64}/
      output_types.zip params
    end
    params = []
    params_tuples.each do |param|
      params << FRM.from_payload(param)
    end

    puts "transform_outputs - transformed outputs:\n #{params.inspect}\n\n"
    params
  end

  # parse output types
  #
  # def parse_types(resp, outputs:)
  #   if resp.is_a? Array
  #     values = resp
  #     values.map.with_index do |value, idx|
  #       output = outputs[idx]
  #       parse_type_read value, type: output["type"]
  #     end
  #   else
  #     output = outputs.first
  #     parse_type_read resp, type: output["type"]
  #   end
  # end

end
