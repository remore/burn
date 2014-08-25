module Burn
  module Fuel
    module Rom
      class Music < DslBase
        def initialize(resource_name, context)
          super(resource_name, context)
          
          @default_tempo = :allegro
          
          if resource_name.nil? then
            raise Exception.new "Resource name for Music class must be provided."
          else
            @resource_name = resource_name
          end
          
          @context.instance_exec resource_name, &lambda{|resource_name|
            @resources["#{resource_name}"] = Array.new
          }
          
        end
        
        def channel(instrument, &block)
          @context.instance_exec(@resource_name,@default_tempo) do |resource_name, default_tempo|
            stream = ChannelStream.new(@resources["#{resource_name}"].count, instrument, default_tempo)
            stream.load(&block)
            @resources["#{resource_name}"] << stream.generate
            #@resources["#{resource_name}"] << "	.byte $43,$1d,$80,$1f,$80,$21,$82,$1d,$80,$1d,$80,$1f,$92"
          end
        end
        
        def tempo(speed)
          @default_tempo = speed
        end
      end
    end
  end
end
