module EksaMination
  module Matchers
    class EqMatcher
      attr_reader :expected
      def initialize(expected); @expected = expected; end
      def matches?(actual); actual == @expected; end
      def failure_message; "is not equal to"; end
      def negative_failure_message; "is equal to"; end
    end
  end
end
