module SimpleUnicorn
  class HttpServer
    attr_accessor :app, :options, :server, :request

    def initialize(app, options = {})
      @app = app
      @options = options
    end

    def start
       #TODO: load configs, store pids

      @server = Kgio::TCPServer.new('0.0.0.0', 9000)
      @request = HttpRequest.new

      loop do
        if client = @server.kgio_tryaccept
          env = @request.read(client)
          status, headers, body = @app.call env

          http_response = SimpleUnicorn::HttpResponse.new status, headers, body
          http_response.write client

          if client && client.closed?
            client.shutdown # in case of fork() in Rack app
            client.close # flush and uncork socket immediately, no keepalive
          end
        end
      end
    end
  end
end