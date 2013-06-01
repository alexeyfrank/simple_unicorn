require 'http/parser'

module SimpleUnicorn
  class Request

    def initialize
      @parser = Http::Parser.new
      @parser.on_message_complete = proc do |env|
        @complete = true
      end

      @parser.on_body = proc do |chunk|
        @request_body = chunk
      end
    end

    def read(socket)
      while !@complete
          @parser << socket.kgio_read!(16384)
      end

      [@parser.status_code, @parser.headers, @request_body]
    end

  end
end