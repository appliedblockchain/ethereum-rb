module ResponseParsing

  private

  # TODO: remove - not used really
  #
  # def parse_get_resp(resp, outputs:)
  #   output_types = []
  #   resp_split = resp.gsub(/^0x/,'').scan /.{64}/
  #   # puts "Resp (raw, split): #{resp_split}" unless DEBUG
  #   formatted_result = outputs.map { |out|  out.fetch "type" }.zip resp_split
  #   puts "Resp (raw, split): #{formatted_result}" unless DEBUG
  #   result = formatted_result.map { |res| FRM.from_payload res }
  #
  #   output = {}
  #   outputs.each_with_index do |out, idx|
  #     output[out["name"]] = result[idx]
  #   end
  #
  #   output = transform_one_key_resp output
  #
  #   output
  # end
  #
  # def transform_one_key_resp(output)
  #   return output unless output.keys == [""]
  #   output[""]
  # end

  # util

  def parse(resp, raw: false)
    begin
      resp = JSON.parse resp
    rescue TypeError => err
      puts "error parsing JSON"
      puts "original:"
      puts "#{resp}\n"
      raise err
    end
    raw ? resp : resp["result"]
  end

  # TODO: types

end
