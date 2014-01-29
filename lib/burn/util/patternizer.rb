module Burn
  module Util
    class Patternizer
      attr_reader :patterns, :width, :height
      def initialize(spr_large)
        @patterns = []
        @width = 0
        @height = 0
        pattern_separator spr_large
      end
      
      include Debug
      
      private
      def patternize(spr)
        pattern_upper = []
        pattern_lower = []
        spr.each_line do |line|
          line.chomp.split(//).each do |c|
            if c==' ' then
              pattern_upper << 0
              pattern_lower << 0
            elsif c=='1' then
              pattern_upper << 1
              pattern_lower << 0
            elsif c=='2' then
              pattern_upper << 0
              pattern_lower << 1
            elsif c=='3' then
              pattern_upper << 1
              pattern_lower << 1
            else
              raise "Invalid Character found at sprite text. Please check you are using accepted charcter[\\s0-3]. \n#{spr}"
            end
          end
        end
        @patterns.push [pattern_upper.join+pattern_lower.join].pack("B*")
      end

      def pattern_separator(spr_large)
        raw=[]
        base_pointer=0
        spr_large.each_line do |line|
          base_pointer=raw.count if !raw[base_pointer].nil? && raw[base_pointer].count>7
          line.chomp.unpack("a8"*(line.length/8)).each_with_index do |data, i|
            raw[base_pointer+i] = [] if raw[base_pointer+i].nil?
            raw[base_pointer+i] << data
          end
          @height+=1
          @width=line.length/8
        end
        @height=@height/8

        raw.each_with_index do |a, i|
          log index:i
          log a
          patternize a.join("\n")
        end
      end
    end
  end
end
