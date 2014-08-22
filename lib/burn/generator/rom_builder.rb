module Burn
  module Generator
    class RomBuilder
      include Fuel::Rom
      include Generator::Rom
      include Debug
      
      def initialize(workspace_root)
        @workspace_root = workspace_root
        
        @game_generator = CSource.new(@workspace_root)
        @music_generator = AssemblyMusic.new(@workspace_root)
        @sound_effect_generator = AssemblySoundEffect.new(@workspace_root)
      end
      
      def verbose(flag)
        Debug::Logger.new.enabled flag
      end
      
      def load(dsl_raw_text)
        self.instance_eval dsl_raw_text
      end
      
      def generate
        @game_generator.generate
        @music_generator.generate
        @sound_effect_generator.generate
      end
      
      def method_missing(method_symbol, *args, &block)
        log :method_symbol=>method_symbol, :args=>args, :block=>block
        if method_symbol == :music then
          Music.new(args[0], @music_generator.get_context).instance_eval(&block) 
          
        elsif method_symbol == :scene then
          # preprocess
          args[0] = "main" if args[0].nil?
          @game_generator.get_context.instance_exec args[0], &lambda{|resource_name|
            [
              "",
              "//#{resource_name} label starts",
              "#{resource_name}:"
            ].each {|p| @code_blocks.push p}
          }
          
          # execute dsls
          Scene.new(args[0], @game_generator.get_context).instance_eval(&block)
          
          # postprocess - To deal with the case of on_enter_frame not found, adding while loop at the end of program
          @game_generator.get_context.instance_exec {@code_blocks.push "ppu_on_all();", "while(1);"}
          
        elsif method_symbol == :declare then
          Declare.new(args[0], @game_generator.get_context).instance_eval(&block) 
        
        elsif method_symbol == :sound then
          Sound.new(args[0], @sound_effect_generator.get_context).instance_eval(&block)
          
          # postprocess
          @game_generator.get_context.instance_exec(@sound_effect_generator.resources.count-1) do |count|
            @global.push "#define SFX_#{args[0].upcase} #{count.to_s}"
          end
          
        end
      end
    end
  end
end
