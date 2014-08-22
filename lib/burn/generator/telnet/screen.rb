module Burn
  module Generator
    module Telnet
      class Screen
        include Debug
        ESC = 27.chr # equal to "\033"
        CLEARSCREEN = ESC + "[2J"
        JUMPTOHOME = ESC + "[H"
        RESETALLATTR = ESC + "[0m"
        
        attr_accessor :display, :fg_color, :bg_color
        
        def initialize(conf)
          @fg_color = 33
          @bg_color = 42
          @conf = conf
          flush_screen
        end
        
        def to_terminal
          CLEARSCREEN + escape_color(@fg_color) + escape_color(@bg_color) + @display.join("\r\n") + JUMPTOHOME + RESETALLATTR
        end
        
        def flush_screen
          @display = Array.new
          @conf.app.height.times{ @display << Array.new(@conf.app.width){' '}.join }
        end
        
        def escape_color(num)
          ESC + "[" + num.to_s + "m"
        end
        
        def is_pressed(key, user_input)
          log " ** program is waiting for:" + key.to_s
          if !user_input.nil? then
            log " **** confiremd user input:" + user_input.class.to_s, user_input.chr, user_input.to_s
            if [*'0'..'9', *'a'..'z', *'A'..'Z'].include?(user_input.chr) && key.to_s == user_input.chr then
              log "****** is_pressed() returned true"
              true
            end
          end
          false
        end
        
      end
    end
  end
end
