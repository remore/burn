module Burn
  module Generator
    module Rom
      class CSource
        include Debug
        attr_reader :global, :code_blocks
        
        def initialize(workspace_root)
          # Generic
          @workspace_root = workspace_root
          @global = Array.new
          @code_blocks = Array.new
          
          # Scene related
          @pattern_tables = Array.new
          @pattern_table_pointer = 80 #0x50 equivalent
          @pattern_table_index = Hash.new
        end
        
        def get_context
          self
        end
        
        def generate
          # Initialization for codeblocks
          @code_blocks.unshift "init();"
          
          # generate source code
          File.write(
            "#{@workspace_root}/tmp/burn/main.c", 
            File.read(File.dirname(__FILE__) + "/template/template.c")
              .gsub(/__@__MAIN__@__/, @code_blocks.join("\n"))
              .gsub(/__@__GLOBAL__@__/, @global.join("\n"))
          )
          
          # save pattern tables associated with source code
          pattern_header = []
          File.open("#{@workspace_root}/tmp/burn/asset/tileset.chr", "rb") do |f|
            pattern_header << f.read(16*80)
          end
          File.open("#{@workspace_root}/tmp/burn/asset/tileset.chr", "wb") do |f|
            f << pattern_header[0]
            @pattern_tables.each do |p|
              f << p
            end
            (8192-16*80-@pattern_tables.count*16).times do |i|
              f << ["0x00"].pack("B*")
            end
          end
          
        end
      end
    end
  end
end
