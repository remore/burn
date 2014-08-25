module Burn
  module Generator
    module Telnet
      class UserInput
        attr_reader :val
        
        def initialize(conf)
          @conf = conf
          @signal = nil
          @val = nil
        end
        
        def receive_signal(signal)
          @signal = signal if @conf.app.user_input ==:enable
        end
        
        def init_for_next_loop
          @val = @signal
          @signal = nil
        end
        
      end
    end
  end
end
