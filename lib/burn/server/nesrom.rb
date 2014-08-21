module Burn
  module Server
    class Nesrom
      require 'webrick'
      
      def initialize(document_root)
        @server = WEBrick::HTTPServer.new({:DocumentRoot => document_root, :BindAddress => '127.0.0.1', :Port => 17890})
        trap 'INT' do 
          @server.shutdown
        end
        @server.mount_proc('/shutdown'){ |req, resp|
          @server.stop
        }
      end
      
      def start
        @server.start
      end
    end
  end
end
