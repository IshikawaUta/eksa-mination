module EksaMination
  module Matchers
    class BeAMatcher
      attr_reader :expected
      def initialize(expected); @expected = expected; end
      def matches?(actual); actual.is_a?(@expected); end
      def failure_message; "is not a kind of"; end
    end
  end
end
