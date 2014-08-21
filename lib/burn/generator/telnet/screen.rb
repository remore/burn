module Burn
  module Generator
    module Telnet
      class Screen
        ESC = 27.chr # equal to "\033"
        CLEARSCREEN = ESC + "[2J"
        JUMPTOHOME = ESC + "[H"
        RESETALLATTR = ESC + "[0m"
        
        attr_accessor :display, :fg_color, :bg_color
        
        def initialize
          @fg_color = 33
          @bg_color = 42
          flush_screen
        end
        
        def to_terminal
          CLEARSCREEN + escape_color(@fg_color) + escape_color(@bg_color) + @display.join("\r\n") + JUMPTOHOME + RESETALLATTR
        end
        
        def flush_screen
          @display = Array.new
          13.times{ @display << Array.new(67){' '}.join }
        end
        
        def escape_color(num)
          ESC + "[" + num.to_s + "m"
        end
        
        def is_pressed(key, user_input)
          puts " ** COOK! PROG=" + key.to_s
          if !user_input.nil? then
            puts " **** COOOOOKKK!! USER=" + user_input.class.to_s
            puts " **** COOOOOKKK!! USER=" + user_input.chr
            puts " **** COOOOOKKK!! USER=" + user_input.to_s
            if [*'0'..'9', *'a'..'z', *'A'..'Z'].include?(user_input.chr) && key.to_s == user_input.chr then
              puts ":: 1 ::::::::::::::::::::::::::::::::::::::------:"
              true
            end
          end
          false
        end
        
      end
    end
  end
end
