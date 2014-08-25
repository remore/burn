module Burn
  module Configuration
    class Loader
      attr_reader :server, :app
      
      def initialize(code)
        @server = Server.new
        @app = App.new
        self.instance_eval code
      end
      
      def method_missing(method_symbol, *args, &block)
        if method_symbol == :config then
          if args[0] == :server then
            @server.instance_eval &block
          elsif args[0] == :app then
            @app.instance_eval &block
          end
        end
      end
    end
  end
end
