module Burn
  module Generator
    module Rom
      class AssemblySoundEffect
        include Debug
        attr_reader :resources
        
        def initialize(workspace_root)
          # Generic
          @workspace_root = workspace_root
          
          # Music related
          @resources = {}
          
        end
        
        def get_context
          self
        end
        
        def generate
          # prepare sound.s - sound effect assembler file
          File.write(
            "#{@workspace_root}/tmp/burn/asset/sounds.s", 
            "sounds:\n" \
              + @resources.keys.map{|p| "	.word @#{p}"}.join("\n") \
              + "\n" \
              + @resources.map{|key,value| "@#{key}:\n#{value.join}	.byte $ff\n" }.join
          )
          
        end
      end
    end
  end
end
