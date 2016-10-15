module Crypto
  # most common algo for ethereum is sha3 (kekkak-sha)

  # TODO: move in Utils::Crypto?

  def sha_sig(content)
    Digest::SHA3.hexdigest(content, 256)[0..7]
  end
end
