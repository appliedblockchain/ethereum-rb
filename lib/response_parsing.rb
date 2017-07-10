module ResponseParsing

  private

  # TODO: move into Utils::ParseJSON or somewhere similar

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

end
