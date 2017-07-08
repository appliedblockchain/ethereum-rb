filter_id = RPC.filter_new

Thread.new do
  while true do
    events = RPC.filter_get filter_id
    events.each do |event|
      topics = event.fetch "topics"
      signature = topics.first
    end

    sleep 5
  end
end

RPC.set contract: :event_demo, method: :trigger, params: ["0x61"]

RPC.set contract: :event_demo_two, method: :trigger, params: ["0x61", "0x62"]

# load interface -> methods -> find type event
