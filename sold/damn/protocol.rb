require 'sold/event_socket'
require 'sold/event_emitter'
require 'sold/damn/packet'
require 'sold/config'
require 'yaml'

LOGGING = true

class Sold::DAmn::Protocol < Sold::EventEmitter
  def initialize
    super()
    emit :init

    @config = Sold::Config.load 'dAmn'
    @sock = Sold::EventSocket.new @config['dAmn']['host'], @config['dAmn']['port']

    @sock.on :packet do |data|
      packet = Sold::Packet.new data
      
      puts packet.raw.yellow if LOGGING

      # TODO: Recurse into subpackets, get recv.msg etc.

      emit packet.cmd, packet
    end

    @sock.on :connect do
      send "dAmnClient 0.3\nagent=%s\n" % @config['dAmn']['agent']
    end

    on 'ping' do
      send "pong\n"
    end
  end
  def connect
    @sock.connect
  end
  def send (pkt)
    unless pkt.is_a? Sold::Packet
      pkt = Sold::Packet.new(pkt)
    end

    puts pkt.raw.gsub("\n", "\\n").red if LOGGING

    @sock.write pkt.raw
  end
end
