module Burn
  module Fuel
    module Rom
      class Note
        # For music
        # (0..59 are octaves 1-5, 63 note stop)
        C = 0
        D = 2
        E = 4
        F = 5
        G = 7
        A = 9
        B = 11
        
        CS = 11
        DS = 1
        ES = 3
        FS = 4
        GS = 6
        AS = 8
        BS = 10
        
        REST = -1
        
        
        # Empty Rows 128~191 (63steps)
        DURATION_BASE = 127
        SIXTEENTH = 4 + DURATION_BASE
        EIGHTH = 10 + DURATION_BASE
        QUARTER = 22 + DURATION_BASE
        HALF = 46 + DURATION_BASE
        DOTTED_SIXTEENTH = 7 + DURATION_BASE
        DOTTED_EIGHTH = 16 + DURATION_BASE
        DOTTED_QUARTER = 34 + DURATION_BASE
        DOTTED_HALF = 70 + DURATION_BASE
        TRIPLET_SIXTEENTH = 1 + DURATION_BASE
        TRIPLET_EIGHTH = 4 + DURATION_BASE
        TRIPLET_QUARTER = 10 + DURATION_BASE
        TRIPLET_HALF = 22 + DURATION_BASE
        
        TENUTO = 1.0
        ACCENT = 0.7
        STACCATO = 0.2
        
        attr_accessor :duration, :articulation, :duration_symbol
        
        def initialize(duration=:quarter, pitch=:c0, articulation=nil, duration_symbol=nil)
          @pitch_list = {c:C, bsharp:C,
                         ds:DS, dflat:DS, csharp:DS,
                         d:D, 
                         es:ES, eflat:ES, dsharp:DS,
                         e:E, fs:FS, fflat:FS,
                         f:F, esharp:F,
                         gs:GS, gflat:GS, fsharp:GS,
                         g:G, 
                         as:AS, aflat:AS, gsharp:AS,
                         a:A, 
                         bs:BS, bflat:BS, asharp:BS,
                         b:B, cs:CS, cflat:CS,
                         rest:REST,
                         }

          # Fix pitch first at this early timing
          if !pitch.to_s.match(/(.+)(\d)/).nil? then
            raise Exception.new "pitch #{pitch.to_s} is not defined." if !@pitch_list.keys.include?(Regexp.last_match(1).to_sym)
            @pitch = @pitch_list[Regexp.last_match(1).to_sym]
            if Regexp.last_match(2).to_i <= 4 then
              @octave = Regexp.last_match(2).to_i
            else
              raise Exception.new "Sorry only 0-4 octave range is supported."
            end
          else
            raise Exception.new "pitch #{pitch.to_s} is not defined." if !@pitch_list.keys.include?(pitch)
            @pitch = @pitch_list[pitch]
            @octave = 0
          end
          
          @duration = duration
          @articulation = articulation
          @duration_symbol = duration_symbol
        end
        
        def generate
          duration = get_actual_duration
          
          result = Array.new
          if @pitch==REST then
            @articuulation = 0
          else
            result << @pitch + 12 * @octave
          end
          
          articulation = Note.const_get(@articulation.upcase) if !@articulation.nil?
          if articulation.nil? then
            result << duration
            result << 63 # note stop
          elsif articulation == TENUTO then
            result << duration + 1
          else
            if (len(duration)*articulation).ceil > 0 then
              result << DURATION_BASE + (len(duration)*articulation).ceil
              result << 63 # note stop
            end
            if (len(duration)*(1.0 - articulation)).floor > 0 then
              result << DURATION_BASE + (len(duration)*(1.0-articulation)).floor
            end
          end
          result
        end
        
        private
        def len(duration)
          duration - DURATION_BASE
        end
        
        def get_actual_duration
          if !@duration_symbol.nil? then
            Note.const_get(@duration_symbol.upcase.to_s + "_" + @duration.upcase.to_s)
          else
            Note.const_get(@duration.upcase.to_s)
          end
        end
      end
    end
  end
end
