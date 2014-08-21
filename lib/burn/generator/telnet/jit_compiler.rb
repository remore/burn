module Burn
  module Generator
    module Telnet
      class JitCompiler
        attr_reader :opcodes
        
        def initialize
          @opcodes = Array.new
        end
        
        def get_context
          self
        end
        
        def compile(source)
          instance_eval source
          @opcodes
        end
        
        def method_missing(method_symbol, *args, &block)
          puts :method_symbol=>method_symbol, :args=>args, :block=>block
          if method_symbol == :scene then
            # preprocess
            args[0] = "main" if args[0].nil?
            
            # execute dsls
            @opcodes << "##{args[0]}"
            Opcode.new(args[0], self).instance_eval(&block)
            @opcodes << "#END"
            
          elsif method_symbol == :declare then
            Declare.new(args[0], self).instance_eval(&block) 
            
          end
        end
      end
    end
  end
end
