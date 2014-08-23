module Burn
  module Generator
    module Telnet
      class Screen
        include Debug
        ESC = 27.chr # equal to "\033"
        CLEARSCREEN = ESC + "[2J"
        JUMPTOHOME = ESC + "[H"
        RESETALLATTR = ESC + "[0m"
        CRLF = 13.chr + 10.chr
        
        attr_accessor :display, :fg_color, :bg_color, :activated_sprite_objects
        
        def initialize(conf)
          @fg_color = 37
          @bg_color = 40
          @activated_sprite_objects = [] # activated sprite objects by #sprite method call during main_loop will be contained
          @conf = conf
          flush_screen
        end
        
        def to_terminal
          #CLEARSCREEN + escape_color(@fg_color) + escape_color(@bg_color) + @display.join("\r\n") + JUMPTOHOME + RESETALLATTR
          #JUMPTOHOME + RESETALLATTR + CLEARSCREEN + escape_color(@fg_color) + escape_color(@bg_color) + @display.join("\r\n") + ESC + "[#{@conf.app.height};2H" + RESETALLATTR
          #CLEARSCREEN + escape_color(@fg_color) + escape_color(@bg_color) + @display.join("\r\n") + ESC + "[#{@conf.app.height};2H" + RESETALLATTR
          #JUMPTOHOME + crlf + crlf + crlf + crlf + crlf + crlf + @display.join(crlf)
          #JUMPTOHOME + crlf + crlf + crlf + crlf + crlf + crlf + @display.join(crlf) + crlf
          #JUMPTOHOME + @display.join(CRLF) + CRLF
          
          JUMPTOHOME +  escape_color(@fg_color) + escape_color(@bg_color) + ppu_emulate + CRLF + RESETALLATTR
          #JUMPTOHOME + @display.join(CRLF) + CRLF
        end
                
        def flush_screen
          @display = Array.new
          @conf.app.height.times{ @display << Array.new(@conf.app.width){' '}.join }
          @activated_sprite_objects = []
        end
        
        def is_pressed(key, user_input)
          log " ** program is waiting for:" + key.to_s
          if !user_input.nil? then
            log " **** confiremd user input:" + user_input.class.to_s, user_input.chr, user_input.to_s
            if [*'0'..'9', *'a'..'z', *'A'..'Z'].include?(user_input.chr) && key.to_s == user_input.chr then
              log "****** is_pressed() returned true"
              return true
            end
          end
          false
        end
        
        private
        
        def escape_color(num)
          ESC + "[" + num.to_s + ";1m"
        end
        
        def ppu_emulate
          if @activated_sprite_objects.count == 0 then
            @display.join(CRLF)
          else
            canvas = @display.map(&:dup) # deep copy
            @activated_sprite_objects.each do |obj|
              obj.tile.split("\n").each_with_index do |line, i|
                canvas[(obj.y+ i) % @conf.app.height][obj.x % @conf.app.width,line.length] = line.chomp
              end
              
#              struct_var = "static sprite_schema #{key}={0, 0, {"
#              @pattern_table_index[key.to_sym] = @pattern_table_pointer
#              patternizer.patterns.each_with_index do |p, i|
#                log p, i, patternizer.height, "aaaaaaaaaaaaaaaaaaa"
#                struct_var += sprintf("%d, %d, %#x, 0,", (i % patternizer.width)*8 , (i / (patternizer.patterns.size / patternizer.height) )*8 , @pattern_table_pointer)
#                @pattern_tables << p
#                @pattern_table_pointer+=1
#              end
#              struct_var += "128}};"
              
            end
            canvas.join(CRLF)
          end
        end
        
      end
    end
  end
end
