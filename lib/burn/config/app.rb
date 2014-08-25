module Burn
  module Configuration
    class App < ConfigBase
      def initialize
        @target = :rom
        @width = 73
        @height = 13
        @frame_rate = :high
        @user_input = :disable
        @verbose = false
        @debug = false
      end
    end
  end
end
