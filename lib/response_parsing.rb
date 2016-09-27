module ResponseParsing

  def parse_get_resp(resp, outputs:)
    output_types = []
    resp_split = resp.gsub(/^0x/,'').scan /.{64}/
    # puts "Resp (raw, split): #{resp_split}" unless DEBUG
    formatted_result = outputs.map { |out|  out.fetch "type" }.zip resp_split
    puts "Resp (raw, split): #{formatted_result}" unless DEBUG
    result = formatted_result.map { |res| FRM.from_payload res }

    output = {}
    outputs.each_with_index do |out, idx|
      output[out["name"]] = result[idx]
    end
    output
  end




  def parse(resp)
    resp = JSON.parse resp
    resp["result"]
  end

  # TODO: types

end
