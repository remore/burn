module Burn
  module Pxes
    class CrubyTranspiler < TranspilerBase
      
      def to_rb
        parse_sexp(@sexp)
      end
      
      private
      #def replace_vcall_to_symbol(sexp_array)
      #  sexp_array.map do |a|
      #    if a.instance_of?(Array) then
      #      replace_vcall_to_symbol(a)
      #    elsif a==:vcall then
      #      :symbol
      #    else
      #      a
      #    end
      #  end
      #end
      
      def invoke_dsl_processing(exp)
        generator = Generator::Telnet::JitCompiler.new
        # class(@@)|instance(@) variable inside exp need to be stringified before the #instance_eval.
        # Without this, variables will be evaluated immediately now (and will get disappered as a result of this) by #instance_eval 
        Fuel::Telnet::Scene.new(@resource_name, generator).instance_eval exp.gsub(/(@[@\w]*)/, "\"\\1\"")
        generator.opcodes.join "\n"
      end
      
      def parse_sexp(s)
        if s.instance_of?(String) then
          s
        elsif s.instance_of?(Array) && s[0].instance_of?(Symbol) then
          log "--array and symbol--"
          log s[0]
          case s[0]
          when :assign
            parse_sexp(s[1]) + "=" + parse_sexp(s[2])
            
          when :var_field, :var_ref
            if s[1][0] == :@ident then
              var_scope = "@___"
            else
              var_scope = ""
            end
            var_scope + s[1][1]
            
          when :void_stmt
            "" # this happens when rip "if true then # do nothing end" type of code
          
          when :binary
            case s[2]
            when :or
              operator = "||"
            when :and
              operator = "&&"
            else
              operator = s[2].to_s
            end
            parse_sexp(s[1]) + operator + parse_sexp(s[3])
            
          when :opassign
            parse_sexp(s[1]) + parse_sexp(s[2]) + parse_sexp(s[3])
            
          when :unary
            case s[1]
            when :not, :!
              "!" + parse_sexp(s[2])
            else
              parse_sexp(s[2])
            end
            
          when :paren
            "(" + parse_sexp(s[1][0]) + ")"
            
          when :symbol
            ':' + s[1][1]
            
          when :field, :call
            parse_sexp(s[1]) + "."  + parse_sexp(s[3])
            
          when :@ident, :@int, :@kw, :@op
            s[1]
            
          when :@tstring_content
            '"' + s[1] + '"'
            
          # this is why you can't use pre-defined dsl name as a variable name. e.g) you are not allowed to declare variables like show or label or stop. these all are defined dsl.
          when :vcall
            if s[1][0] == :@ident then
              var_scope = "@___"
            else
              var_scope = ""
            end
            s[1][1] = var_scope + s[1][1]
            parse_sexp(s[1])
          
          # this is why you can't use pre-defined dsl name as a variable name. e.g) you are not allowed to declare variables like show or label or stop. these all are defined dsl.
          when :command
            if !Fuel::Telnet::Scene.new(@resource_name,@context).methods.index(s[1][1].to_sym).nil? then
              #invoke_dsl_processing parse_sexp(s[1]) + "(" + parse_sexp( replace_vcall_to_symbol(s[2]) ) + ")"
              invoke_dsl_processing parse_sexp(s[1]) + "(" + parse_sexp( s[2] ) + ")"
            else
              parse_sexp(s[1]) + "(" + parse_sexp(s[2]) + ")"
            end
            
          when :method_add_arg
            command = s[1][1][1]
            # check if it matches dsl.
            case command
            when "is_pressed"
              "@screen.is_pressed(" + parse_sexp(s[2]) + ", @user_input.val)"
            #when "rand"
            #  parse_sexp(s[1]) + "8()"
            else
              parse_sexp(s[1]) + "(" + parse_sexp(s[2]) + ")"
            end
            
          # Currently pssing block is not supported
          #when :method_add_block
          
          when :args_add_block
            a = Array.new
            s[1].each_with_index do |sexp,i|
              log "<<<<<<<<<<<<<<<<<<NUM #{i}>>>>>>"
              log sexp
              a << parse_sexp(sexp)
            end
            a.join(",")
            
          when :while
            "while(" + parse_sexp(s[1]) + "){" + parse_sexp(s[2]) + "}"
            
          when :if, :if_mod, :elsif
            if s[0]==:elsif then
              keyword = "else if"
            else
              keyword = "if"
            end
            additional_condition = parse_sexp(s[3]) if !s[3].nil?
            #"#{keyword} (" + parse_sexp(s[1]) + "){" + parse_sexp(s[2]) + "} #{additional_condition}"
            label = "##{@resource_name}-" + [*0-9, *'a'..'z', *'A'..'Z'].sample(10).join
            #"@pc = @opcodes.index(\"#{label}\") if !(" + parse_sexp(s[1]) + ")\n" + parse_sexp(s[2]) + "\n#{label}"
            if additional_condition then
              # jump to else
              # + script for if clause
              # jump to end
              # label for else
              # + script for else
              # label for end
              "@pc = @opcodes.index(\"#{label}\") if !(" + parse_sexp(s[1]) + ")\n" \
                + parse_sexp(s[2]) + "\n" \
                + "@pc = @opcodes.index(\"#{label}-else\")\n" \
                + "#{label}\n" \
                + additional_condition + "\n" \
                + "#{label}-else"
            else
              "@pc = @opcodes.index(\"#{label}\") if !(" + parse_sexp(s[1]) + ")\n" + parse_sexp(s[2]) + "\n#{label}"
            end
            
            
          #when :def
          # is not supported for to_c as return data type cannot be defined
          
          when :else
            parse_sexp(s[1])
            
          else
            parse_sexp(s[1])
            
          end
        # Safety net
        elsif s.instance_of?(Array) && s[0].instance_of?(Array) then
          a = Array.new
          s.each_with_index do |sexp,i|
            log "<<<<<<<<<<<<<<<<<<NUM #{i}>>>>>>"
            log sexp
            a << parse_sexp(sexp)
          end
          a.join("\n")
        else
          log "--else--"
          log s.class.to_s
          log s[0].class.to_s
        end
      end
    end
  end
end
