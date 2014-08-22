module Burn
  module Generator
    module Rom
      class AssemblyMusic
        include Debug
        
        def initialize(workspace_root)
          # Generic
          @workspace_root = workspace_root
          
          # Music related
          @resources = {}
          
          #@channels = Array.new
          
        end
        
        def get_context
          self
        end
        
        def generate
          # prepare music.s - music assembler file
          File.write(
            "#{@workspace_root}/tmp/burn/asset/music.s", 
            File.read("#{@workspace_root}/tmp/burn/asset/music.s")
              .gsub(/__@__EXPORT__@__/, @resources.keys.map{|p| "	.export _music_#{p}"}.join("\n"))
              .gsub(/__@__INCLUDE__@__/, @resources.keys.map{|p| "_music_#{p}: 		.include \"mus_#{p}.s\""}.join("\n"))
          )
          
          # preparing each song file
          @resources.each {|resource_name, channels|
            # prepare other music resources
            File.write( "#{@workspace_root}/tmp/burn/asset/mus_#{resource_name}.s",
              File.read(File.dirname(__FILE__)+"/template/mus_template.s")
                .gsub(/__@__NAME__@__/, resource_name)
                .gsub(/__@__CHANNEL1__@__/, channels.shift || "")
                .gsub(/__@__CHANNEL2__@__/, channels.shift || "")
                .gsub(/__@__CHANNEL3__@__/, channels.shift || "")
                .gsub(/__@__CHANNEL4__@__/, channels.shift || "")
                .gsub(/__@__CHANNEL5__@__/, channels.shift || "")
            )
          }
        
        end
      end
    end
  end
end
