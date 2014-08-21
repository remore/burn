module Burn
  module Generator
    class TelnetVm
      include Fuel::Telnet
      include Generator::Telnet
      attr_reader :screen
      attr_accessor :wait
      
      def initialize(source)
        @pc = 0 # Program Counter
        @screen = Screen.new
        @wait = 10
        @opcodes = JitCompiler.new.compile(source) # compiled methods
        @user_input = nil
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
        #@screen[0] = " #{signal}"
        @user_input = signal
      end
      
    end
  end
end
