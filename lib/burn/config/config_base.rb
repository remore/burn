module Burn
  module Configuration
    class ConfigBase
      def method_missing(method_symbol, *args, &block)
        if instance_variables.include?("@#{method_symbol}".to_sym) then
          if args.count>0 then
            self.instance_variable_set "@#{method_symbol}", args[0]
          else
            self.instance_variable_get "@#{method_symbol}"
          end
        end
      end
      
    end
  end
end
