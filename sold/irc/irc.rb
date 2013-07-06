require 'sold/protocol'

class Sold::IRC < Sold::IRC::Protocol; end

require 'sold/irc/channel'

class Sold::IRC < Sold::IRC::Protocol
  def join (room)
    channel = Sold::IRC::Channel.new room
    send "join %s\n" % channel.to_namespace
  end
  def part (room)
    channel = Sold::IRC::Channel.new room
    send "part %s\n" % channel.to_namespace
  end
  def say (room, msg)
    channel = Sold::IRC::Channel.new room
    send "send %s\n\nmsg main\n\n%s\n" % [channel.to_namespace, msg]
  end
end
