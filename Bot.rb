$: << File.expand_path(File.dirname(__FILE__))

require 'colorize'
require 'sysinfo'
require 'sold/damn/damn'
require 'sold/config'

class Sold::Bot
  attr_reader :damn, :commands, :config
  def initialize ()
    @damn = Sold::DAmn.new
    @commands = {}
    @config = Sold::Config.load 'bot'

    @damn.on 'login' do
      @config['rooms'].each { |room| @damn.join room }
    end

    @damn.on 'dAmnServer' do
      @damn.send(
        :cmd => "login",
        :param => @config['user']['name'],
        :args => {
          pk: @config['user']['authtoken']
        }
      )
    end
    @damn.on 'recv' do |pkt|
      if (pkt.sub[0].cmd === 'msg')
        msg = pkt.sub[0].body
        if (msg.start_with? @config['trigger'])
          parts = msg[@config['trigger'].length..-1].split " "
          @commands[parts[0]].call pkt, parts, msg
        end
      end
    end
  end
  def connect
    @damn.connect
  end
  def add_command (cmd, &block)
    @commands[cmd] = block
  end
end

bot = Sold::Bot.new

bot.add_command 'test' do |pkt, parts, msg|
  room = pkt.param
  
  bot.damn.send "send %s\n\nmsg main\n\n%s" % [room, "hi"]
end

bot.add_command 'join' do |pkt, parts, msg|
  bot.damn.join parts[1]
end

bot.add_command 'eval' do |pkt, parts, msg|
  bot.damn.say pkt.param, "eval will be here eventually"
end

require 'sold/Arguments'

bot.add_command 'args' do |pkt, parts, msg|
  args = Arguments.new msg[bot.config['trigger'].length+5..-1]
  bot.damn.say pkt.param, args.to_json
end

$INFO = {
  :name => 'Sold',
  :version => '0.1.0',
  :authors => ['nuckchorris0']
}

bot.add_command 'about' do |pkt, parts, msg|
  sysinfo = SysInfo.new

  bot.damn.say pkt.param, bot.config['about'] % {
    :name => $INFO[:name],
    :version => $INFO[:version],
    :owner => bot.config['owner'],
    :creators => $INFO[:authors].join(', '),
    :os => sysinfo.impl.to_s,
    :arch => sysinfo.arch.to_s,
    :vm => sysinfo.vm.to_s,
    :rbver => sysinfo.ruby.join('.')
  }
end

bot.connect
