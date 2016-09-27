contract OpReturn {
  bytes32 public data;

  function set(bytes32 _data) {
    data = _data;
  }
}

class OpReturn
  include Contract
  storage data: { type: :bytes32 }

  setters :data
end


# ----

# TODO

module Contract
  def storage

  end

  def setters

  end
end
