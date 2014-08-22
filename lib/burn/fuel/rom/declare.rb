module Burn
  module Fuel
    module Rom
      class Declare < Fuel::DslBase
          
        def initialize(resource_name, context)
          super(resource_name, context)
        end
        
        def method_missing(method_symbol, *args, &block)
          log :method_symbol=>method_symbol, :args=>args, block=>block
          
          proc = Proc.new{|args|
            key=args.shift
            value=args.shift
            if value.is_a?(String) then
              patternizer = Util::Patternizer.new(value)
              
              struct_var = "static sprite_schema #{key}={0, 0, {"
              @pattern_table_index[key.to_sym] = @pattern_table_pointer
              patternizer.patterns.each_with_index do |p, i|
                log p, i, patternizer.height, "aaaaaaaaaaaaaaaaaaa"
                struct_var += sprintf("%d, %d, %#x, 0,", (i % patternizer.width)*8 , (i / (patternizer.patterns.size / patternizer.height) )*8 , @pattern_table_pointer)
                @pattern_tables << p
                @pattern_table_pointer+=1
              end
              struct_var += "128}};"
              
              @global.push sprintf(struct_var, "")
              
            else
              @global.push "static unsigned char #{key};"
              @code_blocks.push "#{key}="+sprintf("%#x", value)+";"
              log :key=>key, :value=>value.to_s(16), :value_class=>value.class
            end
          }

          @context.instance_exec [method_symbol.to_s, args[0]], &proc
        end
      end
    end
  end
end
