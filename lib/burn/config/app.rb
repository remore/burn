module Burn
  module Configuration
    class App < ConfigBase
      def initialize
        @terminal = :rom
        @width = 80
        @height = 24
        @frame_rate = :high
        @user_input = :disable
        @verbose = false
        @debug = false
      end
    end
  end
end
