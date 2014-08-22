module Burn
  module Generator
    class TelnetVm
      include Generator::Telnet
      attr_reader :screen
      attr_accessor :wait
      
      def initialize(source, conf)
        @pc = 0 # Program Counter
        @screen = Screen.new(conf)
        @wait = 10
        @opcodes = JitCompiler.new.compile(source) # compiled methods
        @user_input = nil
        @conf = conf
      end
      
      def next_frame
        if @wait > 0 then
          @wait = @wait - 1
        else 
          puts @user_input
          if @opcodes[@pc] != "#END" then
            @pc = @pc+1
            puts @opcodes[@pc-1]
            self.instance_eval @opcodes[@pc-1]
          elsif (@opcodes.count-1) > @pc then
            @pc = @pc+1
          else
            puts "BooooMM!! Cursor reached the end of opcodes."
          end
        end
      end
      
      def interrupt(signal)
        @user_input = signal if @conf.app.user_input ==:enable
      end
      
    end
  end
end
