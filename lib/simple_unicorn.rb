require "simple_unicorn/version"

module SimpleUnicorn
  autoload :HttpRequest, 'simple_unicorn/http_request'
  autoload :HttpResponse, 'simple_unicorn/http_response'
  autoload :HttpServer, 'simple_unicorn/http_server'
  autoload :Builder, 'simple_unicorn/builder'

  def self.builder(ru)
    Builder.build(ru)
  end
end
