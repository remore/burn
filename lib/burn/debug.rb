module Burn
  module Debug
    class Logger
      @@enabled = false
      
      def enabled(flag)
        @@enabled = flag
      end
      
      def enabled?
        @@enabled
      end
      
      def log(message)
        puts message if @@enabled
      end
    end
  
    def log(*messages)
      messages.each do |message|
        Debug::Logger.new.log message
      end
    end
  end
end
