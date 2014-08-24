module Burn
  module Server
    class Telnet
      require 'eventmachine'
      include Debug
      
      def initialize(fuel, conf)
        @@op = nil
        @@screen_buffer = nil
        @@conf = conf
        @fuel = fuel
        verbose conf.app.verbose
      end
      
      def self.vm
        @@vm
      end
      
      def self.op(receive=nil)
        if receive.nil? then
          @@op
        else
          @@op = receive
        end
      end
      
      def self.conf
        @@conf
      end
      
      class Messenger < EM::Connection
        include Debug
        @@channel = EM::Channel.new
        
        def post_init
          if EM::connection_count <= Telnet.conf.server.max_clients then
            log "-- someone connected"
            @sid = @@channel.subscribe { |data| send_data data }
            log @sid
            # display current screen for newly connected user
            @@channel.push Telnet.vm.screen.to_terminal
          else
            send_data "Burn telnet server refused to establish connection, since there is no remaining connection slots. Please try later."
            close_connection true
          end
        end

        def receive_data(data)
          #@@channel.push data
          #puts data # only shown in server's terminal
          receive = proc do
            #"user=#{@sid} typed [" + data + "]"
            Telnet.vm.interrupt data.ord
            log "...ord=#{data.ord},#{data}"
          end
          Telnet.op receive
        end

        def unbind
          log "-- someone(#{@sid}) disconnected from the server"
          @@channel.unsubscribe(@sid)
        end
        
        def self.publish(message)
          @@channel.push message
        end
        
      end
      
      def start
        @@vm = Generator::TelnetVm.new(@fuel, @@conf)
        
        EM::run do
          EM::start_server(@@conf.server.ip_addr, @@conf.server.port, Messenger)
          
          # view
          EM::add_periodic_timer(frame_rate) do
            if @@vm.screen.to_terminal != @@screen_buffer then
              log "both screen and @screen_buffer is updated!"
              Messenger.publish @@vm.screen.to_terminal
              @@screen_buffer = @@vm.screen.to_terminal
            end
          end
          
          # controller + model
          EM::add_periodic_timer(frame_rate) do
            if !@@op.nil? then
              callback = proc do |s|
               @@op=nil
               log "callback is called."
              end
              EM::defer(@@op, callback)
             log "EM::defer is called."
            end
            @@vm.next_frame
          end
          
          #EM::set_quantum 10
        end
        
      end
      
      private
      
      def frame_rate
        case @@conf.app.frame_rate
        when :high then 0.03
        when :normal then 0.5
        when :slow then 1.0
        else 0.5
        end
      end
      
      def verbose(flag)
        Debug::Logger.new.enabled flag
      end
      
    end
  end
end
