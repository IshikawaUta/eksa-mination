module EksaMination
  module Matchers
    class BeMatcher
      attr_reader :expected
      def initialize(expected); @expected = expected; end
      def matches?(actual); actual.equal?(@expected); end
      def failure_message; "is not the same object as"; end
      def negative_failure_message; "is the same object as"; end
    end
  end
end
