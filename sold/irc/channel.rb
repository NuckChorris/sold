class Sold::DAmn::Channel
  attr_accessor :name, :type
  def initialize (channel)
    return unless /([#&][^\x07\x2C\s]{,200})/ === channel
    case channel
    when /^@/
      @name = room[1..-1]
      @type = :pchat
    when /^pchat:/
      @name = room[6..-1]
      @type = :pchat
    when /^#/
      @name = room[1..-1]
      @type = :chat
    when /^chat:/
      @name = room[5..-1]
      @type = :chat
    end
  end
  def to_namespace
    "%s:%s" % [@type.to_s, @name]
  end
  def to_channel
    "%s%s" % [self.class.symbol(@type), @name]
  end
end
