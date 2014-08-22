module Burn
  module Server
    class Rom
      require 'webrick'
      
      def initialize(document_root, conf)
        @server = WEBrick::HTTPServer.new({:DocumentRoot => document_root, 
                                           :BindAddress => conf.server.ip_addr,
                                           :Port => conf.server.port,
                                           :MaxClients => conf.server.max_clients})
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
