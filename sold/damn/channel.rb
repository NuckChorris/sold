class Sold::DAmn::Channel
  attr_accessor :name, :type
  def self.symbol (type)
    {
      :pchat => '@',
      :chat => '#'
    }[type]
  end
  def initialize (room)
    return unless (/(p?chat:|@|#)[A-Za-z][A-Za-z0-9_\-:]*/ === room)
    case room
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
