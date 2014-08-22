module Burn
  module Generator
    class TelnetVm
      include Generator::Telnet
      include Debug
      attr_reader :screen
      attr_accessor :wait
      
      def initialize(source, conf)
        @pc = 0 # Program Counter
        @screen = Screen.new(conf)
        @wait = 10
        @opcodes = JitCompiler.new.compile(source) # compiled methods
        @user_input = nil
        @conf = conf
        @finish = false
      end
      
      def next_frame
        if @wait > 0 then
          @wait = @wait - 1
        elsif !@finish then
          log @user_input
          if @opcodes[@pc] != "#END" then
            @pc = @pc+1
            log @opcodes[@pc-1]
            self.instance_eval @opcodes[@pc-1]
          elsif (@opcodes.count-1) > @pc then
            @pc = @pc+1
          else
            log "Program counter reached at the end of program. #END"
            @finish = true
          end
        else # if @finish == true then
          # do nothing
        end
      end
      
      def interrupt(signal)
        log "INTTERUPT_SETTING:" + @conf.app.user_input.to_s
        @user_input = signal if @conf.app.user_input ==:enable
      end
      
    end
  end
end
