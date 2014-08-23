module Burn
  module Fuel
    module Telnet
      class Declare < DslBase
          
        def initialize(resource_name, context)
          super(resource_name, context)
        end
        
        def method_missing(method_symbol, *args, &block)
          proc = Proc.new{|args|
            key=args.shift
            value=args.shift
            if value.is_a?(String) then
              @opcodes << "@___#{key} = Sprite.new(\"#{value}\",0,0)"
            else
              @opcodes << "@___#{key} = #{value}"
            end
          }

          @context.instance_exec [method_symbol.to_s, args[0]], &proc
        end
      end
    end
  end
end
