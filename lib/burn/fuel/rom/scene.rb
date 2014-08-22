module Burn
  module Fuel
    module Rom
      class Scene < DslBase
        # Where to draw
        BG = 0          # background palette (0x00-0x0f)
        TEXT = 1        # background palette (0x00-0x0f)
        PALETTE_X1 = 5  # palette A for #screen and #paint method (whcih is a part background palette)
        PALETTE_X2 = 6
        PALETTE_X3 = 7
        PALETTE_Y1 = 9
        PALETTE_Y2 = 10
        PALETTE_Y3 = 11
        PALETTE_Z1 = 13
        PALETTE_Z2 = 14
        PALETTE_Z3 = 15
        SPRITE = 17     # sprite palette (0x10-0x1f)
        
        PALETTE_DEFAULT = 0
        PALETTE_X = 85  # palette expression for PPU Attribute table
        PALETTE_Y = 170 # palette expression for PPU Attribute table
        PALETTE_Z = 255 # palette expression for PPU Attribute table
        
        # Color Control
        WHITE = 0
        LIGHTBLUE = 1
        BLUE = 2
        PURPLE = 3
        PINK = 4
        RED = 5
        DEEPRED = 6
        ORANGE = 7
        LIGHTORANGE = 8
        DARKGREEN = 9
        GREEN = 10
        LIGHTGREEN = 11
        BLUEGREEN = 12
        GRAY = 13
        BLACK = 14
        
        # Light Control
        DARKEST = 0
        DARKER = 16
        LIGHTER = 32
        LIGHTEST = 48
        
        def initialize(resource_name, context)
          super(resource_name, context)
        end
        
        def label(string, x=0, y=1)
          @context.instance_exec {@code_blocks.push sprintf("put_str(NTADR(%d,%d),\"%s\");", x, y, string.upcase)}
        end
        
        def fade_in
          @context.instance_exec do
            [
              "ppu_on_all();",
              "screen_fade_in();"
            ].each {|p| @code_blocks.push p}
          end
        end
        
        def fade_out(sec=3)
          @context.instance_exec {@code_blocks.push "screen_fade_out(#{sec.to_s});"}
        end
        
        def color(palette, color, lightness=:lighter)
          palette=Scene.const_get(palette.upcase)
          color=Scene.const_get(color.upcase)
          lightness=Scene.const_get(lightness.upcase)
          
          @context.instance_exec {@code_blocks.push "pal_col(#{palette},0x#{(lightness+color).to_s(16)});"}
        end
        
        def play(song_title)
          @context.instance_exec do
            @global << "extern const unsigned char music_#{song_title}[];"
            @code_blocks << "music_play(music_#{song_title});"
          end
        end
        
        def stop
          @context.instance_exec {@code_blocks.push "music_stop();"}
        end
        
        def show(string, x=0, y=0, *args)
          @context.instance_exec(@resource_name) do |resource|
            nmi_plots = Array.new
            iChrCount=0
            isRequireArgs=false
            vname = resource+"_nmi_list"
            init_name = resource+"_nmi_init"
            
            string.split(//).each do |c|
              if c=='%' then
                isRequireArgs=true
                next
              end
              nmi_plots.push [x+iChrCount,y] if nmi_plots.index([x+iChrCount, y]).nil?
              if !isRequireArgs then
                @code_blocks.push sprintf("#{vname}[%d]=%s;", nmi_plots.index([x+iChrCount,y])*3+2, sprintf("%#x", c.bytes.to_a[0]-32))
                iChrCount+=1
              else
                if c=='d' then
                  @code_blocks.push sprintf("#{vname}[%d]=0x10+%s;", nmi_plots.index([x+iChrCount,y])*3+2, args.shift)
                  iChrCount+=1
                elsif c=='s' then
                  args.shift.split(//).each do |d|
                    nmi_plots.push [x+iChrCount,y] if nmi_plots.index([x+iChrCount, y]).nil?
                    @code_blocks.push sprintf("#{vname}[%d]=%s;", nmi_plots.index([x+iChrCount,y])*3+2, sprintf("%#x", d.bytes.to_a[0]-32))
                    iChrCount+=1
                  end
                else
                  raise "method #show can't take any data except for %d or %s. Please make sure you are passing correct 4th parameter."
                end
              end
              isRequireArgs=false
            end
            
            if nmi_plots.count>0 then
              # declaration for show method
              @global.push sprintf("static unsigned char #{vname}[%d*3];", nmi_plots.count)
              @global.push sprintf("const unsigned char #{init_name}[%d*3]={", nmi_plots.count)
              nmi_plots.each_with_index do |plot,i|
                @global.push sprintf("MSB(NTADR(%d,%d)),LSB(NTADR(%d,%d)),0%s", plot[0],plot[1],plot[0],plot[1],i<(nmi_plots.count-1)?",":"")
              end
              @global.push "};"
              @code_blocks.unshift "memcpy(#{vname},#{init_name},sizeof(#{init_name}));", sprintf("set_vram_update(%d,#{vname});", nmi_plots.count)
            end
            
          end
        end
        
        def wait(interval)
          #@context.instance_exec do
          #  [
          #    "while(1){",
          #      "ppu_on_all();",
          #      "delay(#{interval});",
          #      "ppu_off();",
          #      "break;",
          #    "}"
          #  ].each {|p| @code_blocks.push p}
          #end
          @context.instance_exec {@code_blocks.push "delay(#{interval});"}
        end
        
        def goto(scene_name)
          @context.instance_exec do
            [
              "ppu_off();",
              "set_vram_update(0,0);", #clear vram condition for #show
              "vram_adr(0x2000);",     #clear nametable
              "vram_fill(0,1024);",    #clear nametable
              "goto #{scene_name};"
            ].each {|p| @code_blocks.push p}
          end
        end
        
        def main_loop(rrb_source=nil)
          rrb_source = File.open("#{@resource_name}.rrb").read if rrb_source.nil? || File.extname(rrb_source) == "#{@resource_name}.rrb"
          
          # preprocess - for show method, all parameters after the 3rd parameter must be converted to String.
          rrb_source = rrb_source.lines.map{|line|
            if /^[\s\t]*show/ =~ line then
              line.chomp.split(",").each_with_index.map{|data, i|
                if i>2 then
                  '"' + data + '"'
                else
                  data
                end
              }.join(",")
            else
              line.chomp
            end
          }.join("\n")
          
          @context.instance_exec(@context,@resource_name) do |c, resource|
            # preprocess
            [
              "ppu_on_all();",
              "while(1){",
                "ppu_waitnmi(); //wait for next TV frame",
            ].each {|p| @code_blocks.push p}
            
            # parse ruby source code and process them partially
            p = Pxes::Cc65Transpiler.new(Ripper.sexp(rrb_source),c,resource)
            #require 'pp'
            #pp p
            @code_blocks.push p.to_c
            
            # postprocess
            @code_blocks.push "}"
          end
          
        end
        
        def inline(code)
          @context.instance_exec {@code_blocks.push code}
        end
        
        #def sprite_set(x,y,tile_number,palette=0)
        #  @context.instance_exec {@code_blocks.push "oam_spr(#{x},#{y},0x"+tile_number.to_s(16)+",#{palette},0);//0x40 is tile number, i&3 is palette"}
        #end
        
        def sprite(resource)
          @context.instance_exec {@code_blocks.push "sprite(&#{resource});"}
        end
        
        def screen(map, vars)
          @context.instance_exec(@resource_name) do |resource|
            current_char = nil
            consective_count = 0
            output = Array.new
            # the last character "\b" is just a dummy to finialize loop process
            (map.gsub(/(\r\n|\r|\n)/,"")+"\b").chars do |c|
              if current_char != c then
                if !current_char.nil? then
                  if vars.keys.include?(current_char.to_sym) then
                    output.push @pattern_table_index[vars[current_char.to_sym].to_sym] # user defined specific pattern
                  else
                    output.push 0 # blank pattern
                  end
                  # repeat to draw same pattern
                  output.push 1, consective_count if consective_count>0
                end
                current_char = c
                consective_count = 0
              else
                consective_count += 1
              end
            end
            @global.push "const unsigned char screen_#{resource}["+(output.count+3).to_s+"]={0x01,"+output.map{|p| sprintf "0x%.2x", p}.join(",")+",0x01,0x00};"
            # "unrle_vram" means "decode Run Length Encoding and set them to vram".
            @code_blocks.push "unrle_vram(screen_#{resource},0x2020);" # previously used 0x2000 but it doesn't display very first line of screen.
          end
        end
        
        def paint(dest, palette)
          @context.instance_exec(@resource_name) do |resource|
            var_name="screen_#{resource}_color_#{@global.count}"
            @global.push "const unsigned char #{var_name}[6]={0x01,0x"+Scene.const_get(palette.upcase).to_s(16)+",0x01,"+sprintf("0x%.2x",dest.end-dest.begin)+",0x01,0x00};"
            @code_blocks.push "unrle_vram(#{var_name},0x"+(9152+dest.begin).to_s(16)+");" # 9152 is equivalent to 23C0
          end
        end
        
        def sound(effect_name)
          @context.instance_exec {@code_blocks.push "sfx_play(SFX_#{effect_name.upcase},0);"}
        end
        
        
        # vcall-ish methods
        def rand
          @context.instance_exec {@code_blocks.push "rand8()"}
        end
        
        alias_method :play_sound, :sound
        alias_method :play_music, :play
        
        # utility methods
        def range(x_from, y_from, x_to, y_to)
          x_to = x_from if x_to.nil?
          y_to = y_from if y_to.nil?
          
          plots = [x_from,y_from,x_to,y_to].map do |v|
            if v.is_a?(String) && v.end_with?("px") then # x:0-255, y:0:239
              v.to_i / 32
            else
              v.to_i / 4
            end
          end
          
          plots[1]*8+plots[0]..plots[3]*8+plots[2]
        end
      end
    end
  end
end
