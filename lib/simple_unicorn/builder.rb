module SimpleUnicorn
  module Builder

    def self.build(ru)
      inner_app = case ru
        when /\.ru$/
          raw = File.read(ru)
          raw.sub!(/^__END__\n.*/, '')
          eval("Rack::Builder.new {(\n#{raw}\n)}.to_app", TOPLEVEL_BINDING, ru)
        else
          require ru
          Object.const_get(File.basename(ru, '.rb').capitalize)
      end

      Rack::Builder.new do
        use Rack::ContentLength
        use Rack::Chunked
        use Rack::CommonLogger, $stderr
        use Rack::ShowExceptions
        use Rack::Lint
        run inner_app
      end.to_app
    end
  end
end