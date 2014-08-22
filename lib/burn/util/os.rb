# refered: http://magazine.rubyist.net/?0017-CodeReview#l17
module Burn
  module Util
    class Os
      @name = ''
      
      def initialize
        @name = RbConfig::CONFIG['host_os']
      end
      
      def is_win?
        return true if @name =~ /mswin(?!ce)|mingw|bccwin/
        false
      end
      
      def is_mac?
        return true if @name =~ /mac|darwin/
        false
      end

      def is_linux?
        return true if @name =~ /linux|cygwin|bsd|solaris|sunos/
        false
      end
      
      def name
        if is_win? then
          "win"
        elsif is_mac? then
          "mac"
        else
          "other"
        end
      end
      
    end
  end
end
