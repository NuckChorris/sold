require 'socket'
require 'sold/event_emitter'

class Sold::EventSocket < Sold::EventEmitter
  attr_reader :sock, :host, :port
  def initialize (host, port)
    @host = host
    @port = port

    super()
  end
  def write (data)
    if @sock
      @sock.write data + "\0"
    end
  end
  def connect
    @sock = TCPSocket.new @host, @port

    emit :connect

    @sock.each_line "\0" do |line|
      emit :packet, line.chomp("\0")
    end
  end
end
