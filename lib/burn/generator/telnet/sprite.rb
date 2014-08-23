module Burn
  module Generator
    module Telnet
      class Sprite
        attr_accessor :tile, :x, :y
        
        def initialize(tile, x, y)
          @tile = tile
          @x = x
          @y = y
        end
        
      end
    end
  end
end
