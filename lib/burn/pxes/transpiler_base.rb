module Burn
  module Pxes
    class TranspilerBase
      include Debug
      attr_reader :sexp
      
      def initialize(sexp, context=nil, resource_name=nil)
        @sexp = sexp
        @context = context || self
        @resource_name = resource_name
      end
    end
  end
end
