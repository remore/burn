module Burn
  module Fuel
    module Telnet
      class Scene < DslBase
        # Where to draw
        BG = 40          # background palette (0x00-0x0f)
        TEXT = 30        # background palette (0x00-0x0f)
        # SPRITE = 17     # sprite palette (0x10-0x1f)
        
        # Color Control
        WHITE = 7
        LIGHTBLUE = 4
        BLUE = 4
        PURPLE = 5
        PINK = 5
        RED = 1
        DEEPRED = 1
        ORANGE = 3
        LIGHTORANGE = 3
        DARKGREEN = 2
        GREEN = 2
        LIGHTGREEN = 6
        BLUEGREEN = 6
        GRAY = 7
        BLACK = 0
        
        # Light Control
        DARKEST = 60
        DARKER = 60
        LIGHTER = 0
        LIGHTEST = 0

        def initialize(resource_name, context)
          super(resource_name, context)
        end
        
        def label(string, x=0, y=1)
          @context.instance_exec { @opcodes << "@screen.display[#{y}][#{x},#{string.length}] = \"#{string.upcase}\"" }
        end

        def wait(interval)
          @context.instance_exec { @opcodes << "@wait = #{interval}" }
        end
        
        def method_missing(method_symbol, *args, &block)
          #TBD if needed
        end
        
        def goto(scene_name)
          @context.instance_exec { @opcodes << "@screen.flush_screen && @pc = @opcodes.index(\"##{scene_name}\")" }
        end
        
        def color(palette, color, lightness=:lighter)
          target = palette==:bg ? "bg" : "fg"
          palette=Scene.const_get(palette.upcase)
          color=Scene.const_get(color.upcase)
          lightness=Scene.const_get(lightness.upcase)
          @context.instance_exec { @opcodes << "@screen.#{target}_color = #{palette+color+lightness}" }
        end
        
        def main_loop(rrb_source=nil)
          @context.instance_exec(@context,@resource_name) do |c, resource|
            p=Pxes::CrubyTranspiler.new(Ripper.sexp(rrb_source),c,resource)
            start_label = "##{resource}-main_loop:" + @opcodes.count.to_s
            @opcodes << start_label
            @opcodes << "@user_input.init_for_next_loop"
            @opcodes.concat p.to_rb.split("\n")
            @opcodes << "@pc = @opcodes.index(\"#{start_label}\")" #JUMP
          end
        end
        
        def sprite(resource)
          @context.instance_exec { @opcodes << "@screen.activated_sprite_objects << @___#{resource} if @screen.activated_sprite_objects.index(@___#{resource}).nil?" }
        end
        
#            def fade_in
#              @context.instance_exec do
#                [
#                  "ppu_on_all();",
#                  "screen_fade_in();"
#                ].each {|p| @code_blocks.push p}
#              end
#            end
#            
#            def fade_out(sec=3)
#              @context.instance_exec {@code_blocks.push "screen_fade_out(#{sec.to_s});"}
#            end
#
#            def show(string, x=0, y=0, *args)
#            end
#            
#            def inline(code)
#            end
#            
#            def screen(map, vars)
#            end
#            
#            def paint(dest, palette)
#            end
#            
#            def rand
#              @context.instance_exec {@code_blocks.push "rand8()"}
#            end
#            
#            # utility methods
#            def range(x_from, y_from, x_to, y_to)
#            end
        
      end
    end
  end
end
