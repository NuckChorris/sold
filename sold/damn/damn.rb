require 'sold/damn/protocol'

class Sold::DAmn < Sold::Protocol; end

require 'sold/damn/channel'

class Sold::DAmn < Sold::Protocol
  def join (room)
    channel = Sold::DAmn::Channel.new room
    send "join %s\n" % channel.to_namespace
  end
  def part (room)
    channel = Sold::DAmn::Channel.new room
    send "part %s\n" % channel.to_namespace
  end
  def say (room, msg)
    channel = Sold::DAmn::Channel.new room
    send "send %s\n\nmsg main\n\n%s\n" % [channel.to_namespace, msg]
  end
end
