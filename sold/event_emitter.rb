module Sold
  class EventEmitter
    def initialize
      @events = {}
    end
    def filter (filter)
      @events.select do |key, val|
        filter === key
      end
    end
    def on (event, &handler)
      @events[event] = handler
    end
    def emit (event, *params)
      self.filter(event).each do |key, handler|
        handler.call *params
      end
    end
  end
end
