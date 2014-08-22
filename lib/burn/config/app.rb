module Burn
  module Configuration
    class App < ConfigBase
      def initialize
        @terminal = :nesrom
        @width = 80
        @height = 24
        @frame_rate = :high
        @user_input = :enable
        @verbose = false
        @debug = false
      end
    end
  end
end
