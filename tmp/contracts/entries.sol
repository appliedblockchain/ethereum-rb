contract Entries {

  mapping(uint => Entry) entries;
  uint public entriesCount = 0;

  struct Entry {
    uint    id;
    bytes32 name;
  }

  function create(bytes32 _name) {
    Entry entry = entries[entriesCount+1];

    if (entry.id != 0) {
     return;
    }

    entry.id   = entriesCount+1;
    entry.name = _name;

    entriesCount++;
  }

  function get(uint id) constant returns (uint _id, bytes32 name) {
    Entry entry = entries[id];

    if (entry.id == 0) {
     return;
    }

    return (
      entry.id,
      entry.name
    );
  }

  function update(uint id, bytes32 _name) {
    Entry entry = entries[id];

    if (entry.id == 0) {
     return;
    }

    entry.name = _name;
  }

  /*function getEntriesCount() constant returns (uint) {
    return entriesCount;
  }*/

}
