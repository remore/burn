module Burn
  module Server
    class Telnet
      require 'eventmachine'
      
      def initialize(fuel)
        @@channel = EM::Channel.new
        @@op = nil
        @@screen_buffer = nil
        @@vm = BurnVM.new(fuel)
      end
      
      class Messenger < EM::Connection
        def post_init
          puts "-- someone connected"
          @sid = @@channel.subscribe { |data| send_data data }
          puts @sid
          puts "Connection num is !!!" + EM::connection_count.to_s # Here is the point to mange NUMBER OF CLIENTS(USERS) (related to max_clients settings)
          # display current screen for newly connected user
          @@channel.push @@vm.screen.to_terminal
        end

        def receive_data(data)
          #@@channel.push data
          #puts data # only shown in server's terminal
          @@op = proc do
            #"user=#{@sid} typed [" + data + "]"
            @@vm.interrupt data.ord
            puts "...ord=#{data.ord},#{data}"
          end
        end

        def unbind
          puts "-- someone(#{@sid}) disconnected from the server"
          @@channel.unsubscribe(@sid)
        end
      end
      
      def start
        EM::run do
          EM::start_server('127.0.0.1', 60000, Messenger)
          
          # view
          EM::add_periodic_timer(0.03) do
            if @@vm.screen.to_terminal != @@screen_buffer then
              puts "@ @ @ @ @ @   @   @  screen is updated!"
              @@channel.push @@vm.screen.to_terminal
              @@screen_buffer = @@vm.screen.to_terminal
            end
          end
          
          # controller + model
          EM::add_periodic_timer(0.03) do
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
    end
  end
end
