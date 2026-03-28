module EksaMination
  module Matchers
    class FalseyMatcher
      def expected; "falsey"; end
      def matches?(actual); !actual; end
      def failure_message; "is not falsey"; end
      def negative_failure_message; "is falsey"; end
    end
  end
end
