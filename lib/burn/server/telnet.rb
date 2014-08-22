module Burn
  module Server
    class Telnet
      require 'eventmachine'
      
      def initialize(fuel, conf)
        @@op = nil
        @@screen_buffer = nil
        @@vm = Generator::TelnetVm.new(fuel, conf)
        @@conf = conf
      end
      
      def self.vm
        @@vm
      end
      
      class Messenger < EM::Connection
        @@channel = EM::Channel.new
        
        def post_init
          puts "-- someone connected"
          @sid = @@channel.subscribe { |data| send_data data }
          puts @sid
          puts "Connection num is !!!" + EM::connection_count.to_s # Here is the point to mange NUMBER OF CLIENTS(USERS) (related to max_clients settings)
          # display current screen for newly connected user
          @@channel.push Telnet.vm.screen.to_terminal
        end

        def receive_data(data)
          #@@channel.push data
          #puts data # only shown in server's terminal
          @@op = proc do
            #"user=#{@sid} typed [" + data + "]"
            Telnet.vm.interrupt data.ord
            puts "...ord=#{data.ord},#{data}"
          end
        end

        def unbind
          puts "-- someone(#{@sid}) disconnected from the server"
          @@channel.unsubscribe(@sid)
        end
        
        def self.publish(message)
          @@channel.push message
        end
      end
      
      def start
        EM::run do
          EM::start_server(@@conf.server.ip_addr, @@conf.server.port, Messenger)
          
          # view
          EM::add_periodic_timer(frame_rate) do
            if @@vm.screen.to_terminal != @@screen_buffer then
              puts "@ @ @ @ @ @   @   @  screen is updated!"
              Messenger.publish @@vm.screen.to_terminal
              @@screen_buffer = @@vm.screen.to_terminal
            end
          end
          
          # controller + model
          EM::add_periodic_timer(frame_rate) do
            if !@@op.nil? then
              callback = proc do |s|
               @@op=nil
              end
              EM::defer(@@op, callback)
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
      
    end
  end
end
