if  RUBY_PLATFORM == 'java'
module I18n
  module Backend
    module Base
      def load_yml(filename)
        begin
          YAML.load(File.open(filename, "r:#{Encoding.default_external.to_s}").read)
        rescue TypeError
          nil
        rescue SyntaxError
          nil
        end
      end
    end
  end
end
end
