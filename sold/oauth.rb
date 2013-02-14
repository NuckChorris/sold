require 'webrick'
require 'uri'
require 'sold/event_emitter'

module Sold::OAuth
  class Browser < EventEmitter
    attr_reader :server
    class Servlet < WEBrick::HTTPServlet::AbstractServlet
      def initialize (server, client_id, block)
        @client_id = client_id
        @port = server[:Port]
        @block = block
        super(server)
      end
      def redirect_uri
        URI "http://localhost:#{@port}/auth/callback"
      end
      def do_GET (req, res)
        case req.path
        when '/auth'
          uri = DeviantART.authorize_path

          query = Hash[URI::decode_www_form uri.query]
          query['client_id'] = @client_id
          query['redirect_uri'] = redirect_uri.to_s

          uri.query = URI::encode_www_form query

          res.set_redirect WEBrick::HTTPStatus::Found, uri
        when '/auth/callback'
          res.body = '<html><body><h1>Authenticated!</h1></body></html>'
          @block.call req.query['code']
        end
      end
    end

    def initialize (args={})
      args = {
        :things => 7
      }.merge(args)

      @server = WEBrick::HTTPServer.new(
        :AccessLog => [],
        :Logger => WEBrick::Log::new("/dev/null", 7),
        :Port => 1337
      )

      when_done = Proc.new do |code|
        @server.shutdown
        puts "Got OAuth2 auth code: #{code}\n"
      end

      @server.mount '/', DeviantART::OAuth::Browser::Servlet, args[:client_id], when_done
    end
  end
end

oauth = DeviantART::OAuth::Browser.new :client_id => 23
oauth.on 'token' do |code|


trap("INT") {
  oauth.server.shutdown
}

puts "Now listening on port #{oauth.server[:Port]}"

oauth.server.start
