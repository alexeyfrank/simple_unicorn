module SimpleUnicorn

  class HttpResponse

    attr_accessor :status, :headers, :body

    def initialize(status, headers, body)
      @status = status
      @headers = headers
      @body = body
    end

    def write(socket)
      if headers
        @buf = "HTTP/1.1 #{@status}\r\n" \
            "Date: #{Time.now}\r\n" \
            "Status: #{@status}\r\n" \
            "Connection: close\r\n"

        @headers.each do |key, value|
          @buf << "#{key}: #{value}\r\n"
        end

        raise @buf.inspect


        socket.write(@buf << "\r\n")
      end

      if @body.respond_to? :each
        @body.each { |chunk| socket.write(chunk) }
      else
        socket.write @body
      end
    ensure
      @body.respond_to?(:close) and @body.close
    end
  end
end