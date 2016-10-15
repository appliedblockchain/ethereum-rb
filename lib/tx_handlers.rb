module TxHandlers

  BLOCK_TIMEOUT_SHORT = 0.3

  private

  # currently used
  #
  # This strategies polls the client for a new block. It resumes code execution as soon as a new block is found (this assumes that you transaction made into a block, which is usually the case of test/dev/private chains - for public chain a simple strategy is to wait for a changed value)  
  #
  def wait_block(last_block)
    time = Time.now
    loop do
      return true if last_block != block_get
      return false if Time.now - time > BLOCK_TIMEOUT_SHORT
      # sleep 0.001 # lowest number #  1ms
      sleep 0.01    # good amount   # 10ms
    end
  end

  # ---

  # OLD STRATEGIES
  #
  # BLOCK_TIMEOUT = 3 # seconds - tx confirmation timeout (wait_for_block)
  #
  # def wait_for_block(last_block)
  #   time = Time.now
  #   loop do
  #     sleep 0.05 && return if last_block != block_get
  #     return if Time.now - time > BLOCK_TIMEOUT
  #     sleep 0.05
  #   end
  # end
  #
  # def wait_for_change(value, &proc)
  #   time = Time.now
  #   loop do
  #     return if value != proc.call
  #     return if Time.now - time > BLOCK_TIMEOUT
  #     puts Time.now - time
  #     sleep 0.1
  #   end
  # end



  # ------


  # unused?
  #
  # def receipt_check(receipt_hash)
  #   t = Time.now
  #   timeout = 1.5 # seconds
  #   while Time.now - t < timeout
  #     resp = receiptz receipt_hash
  #     puts "Receipt: #{resp}"
  #     break if resp
  #     sleep 0.1    # less spam - every 100ms
  #     # sleep 0.05 # 50ms
  #   end
  #   resp
  # end

end
