module Burn
  module Fuel
    module Rom
      class SoundEffect
        # duty cycle: 00：12.5%　01：25%　10：50%　11：75%
        LOWEST = 0
        LOWER = 1
        HIGHER = 2
        HIGHEST = 3
        
        def initialize
          @output_buffer = Array.new
        end
        
        def load(&block)
          self.instance_eval &block
        end
        
        # $4000 related
        def duty_cycle(ratio)
          @duty_cycle = SoundEffect.const_get(ratio.upcase)
        end
        
        def velocity(level)
          @velocity = level
        end
        
        def envelope_decay(flag)
          @envelope_decay = flag==:enable ? 0 : 1
        end
        
        def envelope_decay_loop(flag)
          @envelope_decay_loop = flag==:enable ? 1 : 0
        end
        
        def length_counter_clock(flag)
          @envelope_decay_loop = flag==:enable ? 0 : 1
        end
        
        # $4001 related
        def pitch(i)
          @pitch = i
        end
        
        def length(i)
          @length = i + 15
        end
        
        alias_method :envelope_decay_rate, :velocity
        alias_method :volume, :velocity
        alias_method :envelope, :envelope_decay
        alias_method :envelope_loop, :envelope_decay_loop
        alias_method :key_off_counter, :length_counter_clock
        
        def generate
          if !@duty_cycle.nil? || !@velocity.nil? || @envelope_decay.nil? || @envelope_decay_loop.nil? then
            @duty_cycle = HIGHER if !@duty_cycle.nil?
            @velocity = 7 if @velocity.nil?
            @envelope_decay = 0 if @envelope_decay.nil?
            @envelope_decay_loop = 0 if @envelope_decay_loop.nil?
            
            reg = @duty_cycle*64 + @envelope_decay*32 + @envelope_decay_loop*16 + @velocity
            if @reg4000 != reg then
              @output_buffer << "	.byte $00,$%02x" % reg
              @reg4000 = reg
            end
          end
          
          if !@pitch.nil? then
            if @reg4001 != @pitch then
              @output_buffer << "	.byte $01,$%02x" % @pitch
              @reg4001 = @pitch
            end
          end
          
          @length = 16 if @length.nil?
          @output_buffer << "	.byte $%02x" % @length
          
          # return result
          @output_buffer.join("\n") + "\n"
          
          #"	.byte $00,$7f\n	.byte $01,$ab\n	.byte $02,$01\n	.byte $13\n	.byte $01,$3f\n	.byte $39\n	.byte $01,$1c\n	.byte $13\n	.byte $ff\n"
        end
        
        private
        def __translate
          "	.byte " + @notes.map{|p| "$%02x" % p}.join(",")
        end
      end
    end
  end
end
