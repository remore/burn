module Burn
  module Fuel
    class DslBase
      # blankslate
      instance_methods.each do |m|
        undef_method m unless m.to_s =~ /object_id|__|method|instance_eval?/
      end
      
      include Debug
      
      def initialize(resource_name, context)
        @resource_name = resource_name
        @context = context
      end
      
      def method_missing(method_symbol, *args, &block)
        log :method_symbol=>method_symbol, :args=>args, :block=>block
        raise Exception.new "Unknown DSL '#{method_symbol}' is used."
        
#        # First argument will be block as always
#        args.unshift block
#        if @procs.key? method_symbol then
#          @context.instance_exec args, &@procs[method_symbol]
#        else
#          raise Exception.new "Unknown DSL '#{method_symbol}' is used."
#        end
      end
      
    end
  end
end
