module Burn
  module Fuel
    module Rom
      class ChannelStream
        # tempo 193 ~ 211 (18 levels, 202 is median)
        # see: http://ja.wikipedia.org/wiki/%E6%BC%94%E5%A5%8F%E8%A8%98%E5%8F%B7
        TEMPO_BASE = 192
        PRESTO = 1 + TEMPO_BASE
        ALLEGRO = 2 + TEMPO_BASE
        MODERATO = 3 + TEMPO_BASE
        ANDANTE = 4 + TEMPO_BASE
        ADAGIO = 5 + TEMPO_BASE
        LARGO = 6 + TEMPO_BASE
        
        # instrument number 64~126 (62steps) *note* no sound for 64, 65~72 seems working right now
        BASS = 65
        PIANO = 66
        STRING = 67
        ARPEGGIO = 68
        STEP = 69
        BELL = 70
        ACOUSTIC = 71
        GUITAR = 72
        THEREMIN = 73
        
        def initialize(index, instrument, tempo)
          @index = index
          
          @duration_list = [:half, :quarter, :eighth, :sixteenth]
          @duration_numeric_list = {2=>:half, 4=>:quarter, 8=>:eighth, 16=>:sixteenth}
          @duration_symbol_list = [:dotted, :triplet]
          @articulation_list = [:tenuto, :staccato, :accent]
          @instrument_list = [:piano, :bass]
          
          @notes = Array.new
          @notes << ChannelStream.const_get(tempo.upcase)
          @notes << ChannelStream.const_get(instrument.upcase)  
          
          @default_duration = :quarter
          @default_articulation = nil
          @default_pitch = :c0
          
          @output_buffer = Array.new
        end
        
        def default(*args)
          args.each{ |option|
            if @duration_numeric_list.include?(option) then
              @default_duration = @duration_numeric_list[option]
            elsif @duration_list.include?(option) then
              @default_duration = option
            elsif @articulation_list.include?(option) then 
              @default_articulation = option
            end
          }
        end
        
        def method_missing(method_symbol, *args, &block)
          case method_symbol
          when :segno then
            @output_buffer << __translate
            @output_buffer << "@chn#{@index.to_s}_segno:"
            @notes = Array.new
          when :dal_segno then
            @output_buffer << __translate
            @output_buffer << "	.byte $fe" # end of stream
            @output_buffer << "	.word @chn#{@index.to_s}_segno"
            @notes = Array.new
          else
            note = Note.new(@default_duration, method_symbol, @default_articulation)
            args.each{ |option|
              if @duration_numeric_list.include?(option) then
                note.duration = @duration_numeric_list[option]
              elsif @duration_list.include?(option) then
                note.duration = option
              elsif @articulation_list.include?(option) then 
                note.articulation = option
              elsif @duration_symbol_list.include?(option) then
                note.duration_symbol = option
              end
            }
            @notes.concat note.generate
          end
        end
        
        def load(&block)
          self.instance_eval &block
        end
        
        def generate
          if @notes.count>0 then
            @output_buffer << __translate
          end
          @output_buffer.join("\n")
          # "	.byte " + @notes.map{|p| "$%02x" % p}.join(",")
          # "	.byte $c1,$43,$1d,$80,$1f,$80,$21,$82,$1d,$80,$1d,$80,$1f,$92"
        end
        
        private
        def __translate
          "	.byte " + @notes.map{|p| "$%02x" % p}.join(",")
        end
      end
    end
  end
end
