require 'http/parser'
require 'stringio'

module SimpleUnicorn
  class HttpRequest

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
    }

    REMOTE_ADDR = 'REMOTE_ADDR'.freeze
    RACK_INPUT = 'rack.input'.freeze
    #NULL_IO = StringIO.new ""

    attr_accessor :env
    attr_accessor :parser
    attr_accessor :request_body

    def initialize
      @env = {}
      @request_body = ""
      init_http_parser
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
      e['QUERY_STRING'] = @parser.request_url
      e['PATH_INFO'] = @parser.request_url

      e.merge!(DEFAULTS)
    end

    private
    def init_http_parser
      @parser = Http::Parser.new
      @parser.on_message_complete = proc { |env| @complete = true }
      @parser.on_body = proc { |chunk| @request_body = chunk }
    end
  end
end