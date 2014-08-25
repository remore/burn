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
        log @opcodes.join(":::")
        @user_input = UserInput.new(conf)
        @conf = conf
        @finish = false
      end
      
      def next_frame
        log @pc
        if @wait > 0 then
          @wait = @wait - 1
        elsif !@finish then
          log @user_input
          if @opcodes[@pc] != "#END" && (@opcodes.count-1) > @pc then
            @pc = @pc+1
            # skipping comment out to speed up
            while @opcodes[@pc-1][0] == '#' do
              @pc = @pc+1
            end
            log @opcodes[@pc-1]
            self.instance_eval @opcodes[@pc-1]
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
        @user_input.receive_signal(signal)
      end
      
    end
  end
end
