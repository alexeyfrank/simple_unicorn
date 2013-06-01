require 'http/parser'
require 'stringio'

module SimpleUnicorn
  class Request # < Rack::Request

    DEFAULTS = {
        "rack.errors" => $stderr,
        "rack.multiprocess" => true,
        "rack.multithread" => false,
        "rack.run_once" => false,
        "rack.version" => [1, 1],
        "SCRIPT_NAME" => "",
        "SERVER_NAME" => '',
        "SERVER_PORT" => '',
        'PATH_INFO' => '',
        'QUERY_STRING' => '',


        'rack.url_scheme' => 'http'

        # this is not in the Rack spec, but some apps may rely on it
        #"SERVER_SOFTWARE" => "Unicorn #{Unicorn::Const::UNICORN_VERSION}"
    }

    REMOTE_ADDR = 'REMOTE_ADDR'.freeze
    RACK_INPUT = 'rack.input'.freeze

    NULL_IO = StringIO.new ""

    attr_accessor :env

    def initialize
      @env = {}
      @parser = Http::Parser.new
      @parser.on_message_complete = proc do |env|
        @complete = true
      end

      @parser.on_body = proc do |chunk|
        @request_body = chunk
      end

      @request_body = ""
    end

    def read(socket)
      e = env
      e[REMOTE_ADDR] = socket.kgio_addr


      while !@complete
          @parser << socket.kgio_read!(16384)
      end


      e[RACK_INPUT] = StringIO.new(@request_body.dup)
      e[RACK_INPUT].set_encoding('ASCII-8BIT')
      e['REQUEST_METHOD'] = @parser.http_method

      e.merge!(DEFAULTS)

      #[@parser.status_code, @parser.headers, @request_body]
    end

  end
end