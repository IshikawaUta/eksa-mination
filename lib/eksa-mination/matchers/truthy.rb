module EksaMination
  module Matchers
    class TruthyMatcher
      def expected; "truthy"; end
      def matches?(actual); !!actual; end
      def failure_message; "is not truthy"; end
      def negative_failure_message; "is truthy"; end
    end
  end
end
