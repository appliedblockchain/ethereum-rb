module TxHandlers

  BLOCK_TIMEOUT_SHORT = 0.3

  private

  # currently used
  #
  # This strategies polls the client for a new block. It resumes code execution as soon as a new block is found (this assumes that you transaction made into a block, which is usually the case of test/dev/private chains - for public chain a simple strategy is to wait for a changed value)
  #
  def wait_block(last_block)
    time = Time.now
    block_median_time = block_median_time_env
    loop do
      return true  if last_block != block_get
      return false if Time.now - time > BLOCK_TIMEOUT_SHORT
      # sleep 0.005   # TODO: probably around 5ms is the lowest
      sleep block_median_time || 0.01 # 10ms - good amount for speed (LAN) deployments - 50-100ms - good amount for a international network
    end
  end

  private

  def block_median_time_env
    time = ENV["ETH_BLOCK_MEDIAN_TIME"]
    time.to_i if time
  end

end
