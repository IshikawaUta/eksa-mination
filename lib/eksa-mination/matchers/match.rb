module EksaMination
  module Matchers
    class MatchMatcher
      attr_reader :expected
      def initialize(expected); @expected = expected; end
      def matches?(actual); actual =~ @expected; end
      def failure_message; "does not match pattern"; end
      def negative_failure_message; "matches pattern"; end
    end
  end
end
