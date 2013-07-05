class Sold::Packet
  attr_accessor :cmd, :param, :args, :body
  def sub
    unless @body.nil?
      splat = body.split "\n\n"
      if (splat.length == 2)
        [Sold::Packet.new(body)]
      else 
        splat.map { |sub| Sold::Packet.new sub }
      end
    else
      []
    end
  end
  def raw
    pkt  = "#{@cmd} #{@param}"

    @args.each do |key, val|
      pkt << "\n"
      pkt << "#{key}=#{val}"
    end
    
    unless @body.nil? || @body.empty?
      pkt << "\n\n"
      pkt << @body
    end
    pkt << "\n"
  end
  def initialize (pkt)
    @args = {}
    @sub = []

    if pkt.is_a? Hash
      @cmd = pkt[:cmd]
      @param = pkt[:param]
      @args = pkt[:args]
      @sub = pkt[:sub]
    elsif pkt.is_a? String
      parts = pkt.split "\n\n", 2
      head = parts.shift.split "\n"

      if head[0]['='] == nil
        cmd = head.shift.split " "
        @cmd = cmd.shift
        @param = cmd.shift
      end

      head.each do |line|
        splat = line.split "=", 2
        @args[splat[0]] = splat[1]
      end

      @body = parts.shift || ""
    end
  end
end
