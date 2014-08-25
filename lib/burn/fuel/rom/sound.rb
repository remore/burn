module Burn
  module Fuel
    module Rom
      class Sound < DslBase
        def initialize(resource_name, context)
          super(resource_name, context)
          
          if resource_name.nil? then
            raise Exception.new "Resource name for Sound class must be provided."
          else
            @resource_name = resource_name
          end
          
          @context.instance_exec resource_name, &lambda{|resource_name|
            @resources["#{resource_name}"] = Array.new
          }
          
          @se = SoundEffect.new
          
        end
        
        def effect(&block)
          @context.instance_exec(@resource_name,@se) do |resource_name,se|
            se.load(&block)
            @resources["#{resource_name}"] << se.generate
          end
        end
      end
    end
  end
end
